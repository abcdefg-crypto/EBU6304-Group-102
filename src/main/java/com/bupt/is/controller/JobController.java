package com.bupt.is.controller;

import com.bupt.is.model.ApplicantCV;
import com.bupt.is.model.Application;
import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import com.bupt.is.service.ApplicationService;
import com.bupt.is.service.JobService;
import com.bupt.is.service.UserService;
import com.bupt.is.service.impl.ApplicationServiceImpl;
import com.bupt.is.service.impl.JobServiceImpl;
import com.bupt.is.service.impl.UserServiceImpl;
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

@WebServlet(urlPatterns = {"/jobs", "/jobs/detail", "/jobs/post"})
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
        response.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/jobs/post".equals(servletPath)) {
            doPostJob(request, response);
            return;
        }
        response.sendError(404);
    }

    private void doJobsList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = getRole(request);
        List<Job> jobs = jobService.getAvailableJobs();
        request.setAttribute("role", role);
        request.setAttribute("jobs", jobs);
        request.getRequestDispatcher("/jobs.jsp").forward(request, response);
    }

    private void doJobDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jobId = request.getParameter("jobId");
        Job job = jobService.getJobById(jobId);
        if (job == null) {
            request.setAttribute("error", "岗位不存在");
            request.getRequestDispatcher("/jobs.jsp").forward(request, response);
            return;
        }

        String role = getRole(request);
        boolean canApply = "TA".equals(role) && job.isOpen();
        request.setAttribute("role", role);
        request.setAttribute("job", job);
        request.setAttribute("canApply", canApply);

        String userId = getUserId(request);
        boolean canEditJob = "MO".equals(role) && userId != null && Objects.equals(userId, job.getPostedBy());
        request.setAttribute("canEditJob", canEditJob);

        if ("MO".equals(role)) {
            List<Application> apps = applicationService.getApplicantsForJob(jobId);
            List<ApplicantCV> applicantCvs = new ArrayList<>();
            for (Application a : apps) {
                User u = userService.findById(a.getApplicantId());
                String username = u != null ? u.getUsername() : a.getApplicantId();
                applicantCvs.add(new ApplicantCV(a.getApplicantId(), username, a.getCvPath(), a.getApplicationId()));
            }
            request.setAttribute("applicantCvs", applicantCvs);
        }

        request.getRequestDispatcher("/job_detail.jsp").forward(request, response);
    }

    private void doPostForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = getRole(request);
        request.setAttribute("role", role);
        if (!"MO".equals(role)) {
            request.setAttribute("error", "只有 MO 可以发布岗位");
            request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId != null && !jobId.trim().isEmpty()) {
            String userId = getUserId(request);
            Job existing = jobService.getJobById(jobId.trim());
            if (existing == null) {
                request.setAttribute("error", "岗位不存在");
            } else if (userId == null || !Objects.equals(userId, existing.getPostedBy())) {
                request.setAttribute("error", "只能编辑自己发布的岗位");
            } else {
                request.setAttribute("editJob", existing);
            }
        }

        request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
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
