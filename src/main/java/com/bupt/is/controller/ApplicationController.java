package com.bupt.is.controller;

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

@WebServlet(urlPatterns = {"/applications/apply"})
public class ApplicationController extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationServiceImpl();
    private final JobService jobService = new JobServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"TA".equals(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId == null) {
            response.sendError(400);
            return;
        }

        try {
            User user = userService.findById(sessionUser.userId);
            if (user == null) {
                throw new IllegalArgumentException("user not found");
            }
            applicationService.applyJob(sessionUser.userId, jobId, user.getCvPath());
            response.sendRedirect(request.getContextPath() + "/jobs?applied=1");
        } catch (IllegalArgumentException e) {
            // Forward back to job detail with error.
            Job job = jobService.getJobById(jobId);
            request.setAttribute("role", sessionUser.role);
            request.setAttribute("job", job);
            request.setAttribute("canApply", job != null && job.isOpen());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/job_detail.jsp").forward(request, response);
        }
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
