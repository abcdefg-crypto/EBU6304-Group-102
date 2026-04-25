package com.bupt.is.controller;

import com.bupt.is.model.Application;
import com.bupt.is.model.ApplicantProfile;
import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import com.bupt.is.service.ApplicationService;
import com.bupt.is.service.JobService;
import com.bupt.is.service.UserService;
import com.bupt.is.service.impl.ApplicationServiceImpl;
import com.bupt.is.service.impl.JobServiceImpl;
import com.bupt.is.service.impl.UserServiceImpl;
import com.bupt.is.util.GsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@WebServlet(urlPatterns = {"/jobs", "/jobs/detail", "/jobs/post", "/jobs/close", "/jobs/applicants", "/jobs/applicant-detail"})
public class JobController extends HttpServlet {

    private final JobService jobService = new JobServiceImpl();
    private final ApplicationService applicationService = new ApplicationServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/jobs".equals(servletPath)) {
            doJobsList(request, response);
            return;
        }
        if ("/jobs/detail".equals(servletPath)) {
            doJobDetail(request, response);
            return;
        }
        if ("/jobs/post".equals(servletPath)) {
            doPostForm(request, response);
            return;
        }
        if ("/jobs/applicants".equals(servletPath)) {
            doApplicantsList(request, response);
            return;
        }
        if ("/jobs/applicant-detail".equals(servletPath)) {
            doApplicantDetail(request, response);
            return;
        }
        response.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/jobs/post".equals(servletPath)) {
            doPostJob(request, response);
            return;
        }
        if ("/jobs/close".equals(servletPath)) {
            doCloseJob(request, response);
            return;
        }
        response.sendError(404);
    }

    private void doJobsList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = getRole(request);
        String userId = getUserId(request);
        String view = request.getParameter("view");
        String keyword = request.getParameter("keyword");
        boolean searchMode = keyword != null && !keyword.trim().isEmpty();
        boolean moManagementView = "MO".equals(role) && view != null && !view.trim().isEmpty();
        List<Job> jobs = moManagementView
                ? (searchMode ? jobService.searchAllJobs(keyword) : jobService.getAllJobs())
                : (searchMode ? jobService.searchAvailableJobs(keyword) : jobService.getAvailableJobs());

        // MO manage views should only see jobs posted by current MO.
        if ("MO".equals(role) && userId != null && view != null && !view.trim().isEmpty()) {
            List<Job> owned = new ArrayList<>();
            for (Job j : jobs) {
                if (Objects.equals(userId, j.getPostedBy())) {
                    owned.add(j);
                }
            }
            jobs = owned;
        }

        request.setAttribute("role", role);
        request.setAttribute("jobs", jobs);
        request.setAttribute("keyword", keyword == null ? "" : keyword.trim());
        request.setAttribute("searchMode", searchMode);
        request.getRequestDispatcher("/jobs.jsp").forward(request, response);
    }

    private void doJobDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jobId = request.getParameter("jobId");
        Job job = jobService.getJobById(jobId);
        if (job == null) {
            request.setAttribute("error", "Job not found");
            request.getRequestDispatcher("/jobs.jsp").forward(request, response);
            return;
        }

        String role = getRole(request);
        boolean canApply = "TA".equals(role) && job.isOpen();
        request.setAttribute("role", role);
        request.setAttribute("job", job);

        String userId = getUserId(request);
        boolean hasApplied = false;
        if ("TA".equals(role) && userId != null) {
            List<Application> myApplications = applicationService.getUserApplications(userId);
            for (Application a : myApplications) {
                if (Objects.equals(jobId, a.getJobId())) {
                    hasApplied = true;
                    break;
                }
            }
        }
        request.setAttribute("hasApplied", hasApplied);
        request.setAttribute("canApply", canApply && !hasApplied);

        boolean canEditJob = "MO".equals(role) && userId != null && Objects.equals(userId, job.getPostedBy());
        request.setAttribute("canEditJob", canEditJob);
        request.setAttribute("canCloseJob", canEditJob && job.isOpen());

        if ("MO".equals(role)) {
            List<Application> apps = applicationService.getApplicantsForJob(jobId);
            java.util.Map<String, String> applicantNameMap = new java.util.HashMap<>();
            for (Application a : apps) {
                User u = userService.findById(a.getApplicantId());
                String username = u != null ? u.getUsername() : a.getApplicantId();
                applicantNameMap.put(a.getApplicantId(), username);
            }
            request.setAttribute("applications", apps);
            request.setAttribute("applicantNameMap", applicantNameMap);
        }

        request.getRequestDispatcher("/job_detail.jsp").forward(request, response);
    }

    private void doPostForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = getRole(request);
        request.setAttribute("role", role);
        if (!"MO".equals(role)) {
            request.setAttribute("error", "Only MO can post jobs");
            request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId != null && !jobId.trim().isEmpty()) {
            String userId = getUserId(request);
            Job existing = jobService.getJobById(jobId.trim());
            if (existing == null) {
                request.setAttribute("error", "Job not found");
            } else if (userId == null || !Objects.equals(userId, existing.getPostedBy())) {
                request.setAttribute("error", "You can only edit jobs posted by yourself");
            } else {
                request.setAttribute("editJob", existing);
            }
        }

        request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
    }


    private void doCloseJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"MO".equals(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId == null || jobId.trim().isEmpty()) {
            response.sendError(400);
            return;
        }

        User mo = userService.findById(sessionUser.userId);
        if (mo == null) {
            response.sendError(403);
            return;
        }

        try {
            jobService.closeJob(jobId.trim(), mo);
            String returnTo = request.getParameter("returnTo");
            if ("detail".equalsIgnoreCase(returnTo)) {
                response.sendRedirect(request.getContextPath() + "/jobs/detail?jobId=" + jobId.trim() + "&closed=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/jobs?view=manage-jobs&closed=1");
            }
        } catch (IllegalArgumentException e) {
            Job job = jobService.getJobById(jobId.trim());
            request.setAttribute("role", sessionUser.role);
            request.setAttribute("job", job);
            request.setAttribute("error", e.getMessage());
            if (job != null) {
                request.setAttribute("canEditJob", Objects.equals(sessionUser.userId, job.getPostedBy()));
                request.setAttribute("canCloseJob", Objects.equals(sessionUser.userId, job.getPostedBy()) && job.isOpen());
                List<Application> apps = applicationService.getApplicantsForJob(jobId.trim());
                java.util.Map<String, String> applicantNameMap = new java.util.HashMap<>();
                for (Application a : apps) {
                    User u = userService.findById(a.getApplicantId());
                    applicantNameMap.put(a.getApplicantId(), u != null ? u.getUsername() : a.getApplicantId());
                }
                request.setAttribute("applications", apps);
                request.setAttribute("applicantNameMap", applicantNameMap);
            }
            request.getRequestDispatcher("/job_detail.jsp").forward(request, response);
        }
    }

    private void doPostJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"MO".equals(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String module = request.getParameter("module");
        String requiredSkills = request.getParameter("requiredSkills");
        String maxApplicantsStr = request.getParameter("maxApplicants");
        String jobIdParam = request.getParameter("jobId");

        int maxApplicants;
        try {
            maxApplicants = Integer.parseInt(maxApplicantsStr);
        } catch (Exception e) {
            forwardPostJobError(request, response, sessionUser, jobIdParam, "maxApplicants must be a number");
            return;
        }

        List<String> skills = parseSkills(requiredSkills);

        Job job = new Job();
        job.setTitle(title);
        job.setDescription(description);
        job.setModule(module);
        job.setRequiredSkills(skills);
        job.setMaxApplicants(maxApplicants);

        User mo = userService.findById(sessionUser.userId);
        if (mo == null) {
            forwardPostJobError(request, response, sessionUser, jobIdParam, "user not found");
            return;
        }

        try {
            if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
                job.setJobId(jobIdParam.trim());
                jobService.updateJob(job, mo);
                response.sendRedirect(request.getContextPath() + "/jobs?updated=1");
            } else {
                jobService.postJob(job, mo);
                response.sendRedirect(request.getContextPath() + "/jobs?posted=1");
            }
        } catch (IllegalArgumentException e) {
            forwardPostJobError(request, response, sessionUser, jobIdParam, e.getMessage());
        }
    }

    private void forwardPostJobError(HttpServletRequest request, HttpServletResponse response,
                                     SessionUser sessionUser, String jobIdParam, String message)
            throws ServletException, IOException {
        request.setAttribute("role", sessionUser.role);
        request.setAttribute("error", message);
        if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
            Job existing = jobService.getJobById(jobIdParam.trim());
            if (existing != null && Objects.equals(sessionUser.userId, existing.getPostedBy())) {
                request.setAttribute("editJob", existing);
            }
        }
        request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
    }

    private static List<String> parseSkills(String requiredSkills) {
        if (requiredSkills == null) {
            return List.of();
        }
        String s = requiredSkills.trim();
        if (s.isEmpty()) {
            return List.of();
        }
        // Accept comma/semicolon/newline separated tokens.
        String[] tokens = s.split("[,;\\n\\r]+");
        List<String> out = new ArrayList<>();
        for (String t : tokens) {
            String x = t.trim();
            if (!x.isEmpty()) {
                out.add(x);
            }
        }
        return out;
    }

    private void doApplicantsList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"MO".equals(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId == null || jobId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jobs?view=manage-applicants");
            return;
        }

        Job job = jobService.getJobById(jobId.trim());
        if (job == null || !Objects.equals(sessionUser.userId, job.getPostedBy())) {
            response.sendError(403);
            return;
        }

        List<Application> applications = applicationService.getApplicantsForJob(job.getJobId());
        List<java.util.Map<String, String>> rows = new ArrayList<>();
        for (Application app : applications) {
            User applicant = userService.findById(app.getApplicantId());
            ApplicantProfile profile = applicant == null ? null : parseApplicantProfile(applicant.getProfile());
            String applicantName = profile != null && profile.getName() != null && !profile.getName().trim().isEmpty()
                    ? profile.getName()
                    : (applicant != null ? applicant.getUsername() : app.getApplicantId());
            String studentId = profile != null && profile.getStudentId() != null ? profile.getStudentId() : "-";

            java.util.Map<String, String> row = new java.util.HashMap<>();
            row.put("applicationId", app.getApplicationId());
            row.put("applicantId", app.getApplicantId());
            row.put("name", applicantName);
            row.put("studentId", studentId);
            row.put("status", app.getStatus() == null ? "PENDING" : app.getStatus());
            row.put("appliedAt", app.getAppliedAt() == null ? "-" : app.getAppliedAt());
            rows.add(row);
        }

        request.setAttribute("role", sessionUser.role);
        request.setAttribute("job", job);
        request.setAttribute("rows", rows);
        request.getRequestDispatcher("/mo_applicants.jsp").forward(request, response);
    }

    private void doApplicantDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"MO".equals(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        String jobId = request.getParameter("jobId");
        String applicantId = request.getParameter("applicantId");
        if (jobId == null || applicantId == null || jobId.trim().isEmpty() || applicantId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jobs?view=manage-applicants");
            return;
        }

        Job job = jobService.getJobById(jobId.trim());
        if (job == null || !Objects.equals(sessionUser.userId, job.getPostedBy())) {
            response.sendError(403);
            return;
        }

        User applicant = userService.findById(applicantId.trim());
        if (applicant == null) {
            response.sendError(404);
            return;
        }

        Application target = null;
        List<Application> applications = applicationService.getApplicantsForJob(job.getJobId());
        for (Application a : applications) {
            if (Objects.equals(a.getApplicantId(), applicantId.trim())) {
                target = a;
                break;
            }
        }
        if (target == null) {
            response.sendError(404);
            return;
        }

        ApplicantProfile profile = parseApplicantProfile(applicant.getProfile());
        request.setAttribute("role", sessionUser.role);
        request.setAttribute("job", job);
        request.setAttribute("application", target);
        request.setAttribute("applicant", applicant);
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/mo_applicant_detail.jsp").forward(request, response);
    }

    private static ApplicantProfile parseApplicantProfile(String profileJson) {
        if (profileJson == null || profileJson.trim().isEmpty()) {
            return new ApplicantProfile("", "", "", "", "");
        }
        try {
            return GsonUtil.fromJson(profileJson, ApplicantProfile.class);
        } catch (Exception e) {
            return new ApplicantProfile("", "", "", "", "");
        }
    }

    private static String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("role");
    }

    private static String getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("userId");
    }

    private static SessionUser requireSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            throw new IllegalArgumentException("Please login first");
        }
        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        if (userId == null || role == null) {
            throw new IllegalArgumentException("Please login first");
        }
        return new SessionUser(userId, role);
    }

    private record SessionUser(String userId, String role) {
    }
}
