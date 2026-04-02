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
import java.util.Arrays;
import java.util.List;

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
        }
        request.getRequestDispatcher("/mo_post_job.jsp").forward(request, response);
    }

    private void doPostJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser = requireSessionUser(request);
        if (!"MO".equals(sessionUser.role)) {
            throw new IllegalArgumentException("Only MO can post jobs");
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String module = request.getParameter("module");
        String requiredSkills = request.getParameter("requiredSkills");
        String maxApplicantsStr = request.getParameter("maxApplicants");

        int maxApplicants;
        try {
            maxApplicants = Integer.parseInt(maxApplicantsStr);
        } catch (Exception e) {
            throw new IllegalArgumentException("maxApplicants must be a number");
        }

        List<String> skills = parseSkills(requiredSkills);

        Job job = new Job();
        job.setTitle(title);
        job.setDescription(description);
        job.setModule(module);
        job.setRequiredSkills(skills);
        job.setMaxApplicants(maxApplicants);

        User mo = userService.findById(sessionUser.userId);
        jobService.postJob(job, mo);
        response.sendRedirect(request.getContextPath() + "/jobs?posted=1");
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
