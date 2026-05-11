package com.bupt.is.controller;

import com.bupt.is.model.AdminApplicationRow;
import com.bupt.is.model.ApplicantProfile;
import com.bupt.is.model.Application;
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

@WebServlet(urlPatterns = {"/admin/applications"})
public class AdminController extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationServiceImpl();
    private final JobService jobService = new JobServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser;
        try {
            sessionUser = requireSessionUser(request);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!isAdminRole(sessionUser.role)) {
            response.sendError(403);
            return;
        }

        List<AdminApplicationRow> rows = new ArrayList<>();
        for (Application app : applicationService.getAllApplications()) {
            AdminApplicationRow row = new AdminApplicationRow();
            row.setApplicationId(app.getApplicationId());
            row.setJobId(app.getJobId());
            row.setApplicantId(app.getApplicantId());
            row.setStatus(app.getStatus() == null ? "PENDING" : app.getStatus());
            row.setAppliedAt(app.getAppliedAt() == null ? "-" : app.getAppliedAt());
            row.setScore(app.getScore());
            row.setCvPath(app.getCvPath());

            Job job = jobService.getJobById(app.getJobId());
            if (job != null) {
                row.setJobTitle(job.getTitle());
                row.setJobModule(job.getModule() == null ? "-" : job.getModule());
            } else {
                row.setJobTitle("(job removed or unknown)");
                row.setJobModule("-");
            }

            User applicant = userService.findById(app.getApplicantId());
            ApplicantProfile profile = applicant == null ? null : parseApplicantProfile(applicant.getProfile());
            String display = profile != null && profile.getName() != null && !profile.getName().trim().isEmpty()
                    ? profile.getName().trim()
                    : (applicant != null ? applicant.getUsername() : app.getApplicantId());
            row.setApplicantDisplayName(display);

            rows.add(row);
        }

        request.setAttribute("role", sessionUser.role);
        request.setAttribute("rows", rows);
        request.setAttribute("totalCount", rows.size());
        request.getRequestDispatcher("/admin_applications.jsp").forward(request, response);
    }

    private static boolean isAdminRole(String role) {
        return "ADMIN".equalsIgnoreCase(role) || "ADMINISTRATOR".equalsIgnoreCase(role);
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
