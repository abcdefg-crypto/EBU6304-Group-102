package com.bupt.is.controller;

import com.bupt.is.model.Application;
import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import com.bupt.is.service.AdminService;
import com.bupt.is.service.ApplicationService;
import com.bupt.is.service.JobService;
import com.bupt.is.service.UserService;
import com.bupt.is.service.impl.AdminServiceImpl;
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
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/admin", "/admin/home", "/admin/workload", "/admin/applications", "/admin/report"})
public class AdminController extends HttpServlet {

    private final AdminService adminService = new AdminServiceImpl();
    private final UserService userService = new UserServiceImpl();
    private final ApplicationService applicationService = new ApplicationServiceImpl();
    private final JobService jobService = new JobServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role) && !"ADMINISTRATOR".equals(role)) {
            response.sendError(403);
            return;
        }

        String servletPath = request.getServletPath();
        request.setAttribute("role", role);

        switch (servletPath) {
            case "/admin":
            case "/admin/home":
                request.getRequestDispatcher("/admin_home.jsp").forward(request, response);
                break;
            case "/admin/workload":
                showWorkload(request, response);
                break;
            case "/admin/applications":
                showApplications(request, response);
                break;
            case "/admin/report":
                showReport(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    private void showWorkload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Integer> workloads = adminService.getAllWorkloads();
        List<Map<String, Object>> taWorkloads = new ArrayList<>();

        int totalAssigned = 0;
        int maxWorkload = 0;
        int minWorkload = Integer.MAX_VALUE;

        for (Map.Entry<String, Integer> entry : workloads.entrySet()) {
            String taId = entry.getKey();
            int wl = entry.getValue();
            User ta = userService.findById(taId);

            Map<String, Object> taInfo = new LinkedHashMap<>();
            taInfo.put("userId", taId);
            taInfo.put("username", ta != null ? ta.getUsername() : taId);
            taInfo.put("workload", wl);

            List<Application> allApps = applicationService.getUserApplications(taId);
            List<Map<String, String>> acceptedApps = new ArrayList<>();
            for (Application app : allApps) {
                if ("ACCEPTED".equalsIgnoreCase(app.getStatus())) {
                    Job job = jobService.getJobById(app.getJobId());
                    Map<String, String> appInfo = new LinkedHashMap<>();
                    appInfo.put("applicationId", app.getApplicationId());
                    appInfo.put("jobId", app.getJobId());
                    appInfo.put("jobTitle", job != null ? job.getTitle() : "Unknown");
                    appInfo.put("jobModule", job != null ? job.getModule() : "-");
                    appInfo.put("appliedAt", app.getAppliedAt() != null ? app.getAppliedAt() : "-");
                    appInfo.put("taName", ta != null ? ta.getUsername() : taId);
                    acceptedApps.add(appInfo);
                }
            }
            taInfo.put("acceptedApplications", acceptedApps);
            taWorkloads.add(taInfo);

            totalAssigned += wl;
            if (wl > maxWorkload) maxWorkload = wl;
            if (wl < minWorkload) minWorkload = wl;
        }

        if (workloads.isEmpty()) {
            minWorkload = 0;
        }

        double avgWorkload = workloads.isEmpty() ? 0 : (double) totalAssigned / workloads.size();

        request.setAttribute("taWorkloads", taWorkloads);
        request.setAttribute("totalTAs", workloads.size());
        request.setAttribute("totalAssigned", totalAssigned);
        request.setAttribute("maxWorkload", maxWorkload);
        request.setAttribute("minWorkload", minWorkload);
        request.setAttribute("avgWorkload", Math.round(avgWorkload * 10.0) / 10.0);
        request.getRequestDispatcher("/admin_workload.jsp").forward(request, response);
    }

    private void showApplications(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Application> allApplications = adminService.getAllApplications();
        List<Map<String, String>> applicationRows = new ArrayList<>();

        for (Application app : allApplications) {
            Job job = jobService.getJobById(app.getJobId());
            User applicant = userService.findById(app.getApplicantId());
            String status = app.getStatus() == null ? "PENDING" : app.getStatus().trim().toUpperCase();
            String statusText = "waiting";
            if ("ACCEPTED".equals(status)) {
                statusText = "admitted";
            } else if ("REJECTED".equals(status)) {
                statusText = "rejected";
            }

            Map<String, String> row = new LinkedHashMap<>();
            row.put("applicationId", app.getApplicationId());
            row.put("applicantId", app.getApplicantId());
            row.put("applicantName", applicant != null ? applicant.getUsername() : app.getApplicantId());
            row.put("jobTitle", job != null ? job.getTitle() : "Unknown");
            row.put("module", job != null ? job.getModule() : "-");
            row.put("statusText", statusText);
            row.put("appliedAt", app.getAppliedAt() != null ? app.getAppliedAt() : "-");
            row.put("rejectionReason", app.getRejectionReason() != null ? app.getRejectionReason() : "");
            applicationRows.add(row);
        }

        request.setAttribute("allApplications", applicationRows);
        request.getRequestDispatcher("/admin_applications.jsp").forward(request, response);
    }

    private void showReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Integer> workloads = adminService.getAllWorkloads();
        List<Map<String, Object>> reportRows = new ArrayList<>();
        int totalAssigned = 0;

        for (Map.Entry<String, Integer> entry : workloads.entrySet()) {
            String taId = entry.getKey();
            int workload = entry.getValue();
            User ta = userService.findById(taId);
            List<Application> allApps = applicationService.getUserApplications(taId);

            Map<String, Integer> moduleCounts = new LinkedHashMap<>();
            for (Application app : allApps) {
                if (!"ACCEPTED".equalsIgnoreCase(app.getStatus())) {
                    continue;
                }
                Job job = jobService.getJobById(app.getJobId());
                String module = job != null ? job.getModule() : "-";
                moduleCounts.put(module, moduleCounts.getOrDefault(module, 0) + 1);
            }

            String modulesSummary = moduleCounts.entrySet().stream()
                    .map(e -> e.getKey() + ": " + e.getValue())
                    .collect(Collectors.joining("; "));
            if (modulesSummary.isEmpty()) {
                modulesSummary = "-";
            }

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("userId", taId);
            row.put("username", ta != null ? ta.getUsername() : taId);
            row.put("workload", workload);
            row.put("modulesSummary", modulesSummary);
            reportRows.add(row);
            totalAssigned += workload;
        }

        request.setAttribute("reportRows", reportRows);
        request.setAttribute("totalTAs", workloads.size());
        request.setAttribute("totalAssigned", totalAssigned);
        request.getRequestDispatcher("/admin_report.jsp").forward(request, response);
    }
}
