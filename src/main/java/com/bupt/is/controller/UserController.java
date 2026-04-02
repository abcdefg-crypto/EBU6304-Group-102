package com.bupt.is.controller;

import com.bupt.is.model.ApplicantProfile;
import com.bupt.is.model.User;
import com.bupt.is.service.UserService;
import com.bupt.is.service.impl.UserServiceImpl;
import com.bupt.is.util.GsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(urlPatterns = {"/user/register", "/user/profile", "/user/cv/upload"})
@MultipartConfig
public class UserController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/user/profile".equals(servletPath)) {
            doProfileGet(request, response);
            return;
        }
        response.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        try {
            if ("/user/register".equals(servletPath)) {
                doRegister(request, response);
                return;
            }
            if ("/user/profile".equals(servletPath)) {
                doProfilePost(request, response);
                return;
            }
            if ("/user/cv/upload".equals(servletPath)) {
                doCvUpload(request, response);
                return;
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            if ("/user/register".equals(servletPath)) {
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
            }
            return;
        }
        response.sendError(404);
    }

    private void doRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String role = request.getParameter("role");

        ApplicantProfile profile = new ApplicantProfile(name, studentId);

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setProfile(GsonUtil.toJson(profile));
        user.setRoles(roleToRoles(role));

        userService.createProfile(user);
        response.sendRedirect(request.getContextPath() + "/login.jsp?registered=1");
    }

    private void doProfileGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser = requireSessionUser(request);
        User user = userService.findById(sessionUser.userId);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        ApplicantProfile profile = parseApplicantProfile(user.getProfile());
        request.setAttribute("user", user);
        request.setAttribute("profile", profile);
        request.setAttribute("role", sessionUser.role);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void doProfilePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser = requireSessionUser(request);
        User existing = userService.findById(sessionUser.userId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");

        ApplicantProfile profile = new ApplicantProfile(name, studentId);
        existing.setEmail(email);
        existing.setProfile(GsonUtil.toJson(profile));

        userService.updateProfile(existing);
        response.sendRedirect(request.getContextPath() + "/user/profile?updated=1");
    }

    private void doCvUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUser sessionUser = requireSessionUser(request);
        if (!"TA".equals(sessionUser.role) && !"MO".equals(sessionUser.role)) {
            throw new IllegalArgumentException("Only TA/MO can upload CV in this demo");
        }

        Part cvPart = request.getPart("cv");
        if (cvPart == null || cvPart.getSize() <= 0) {
            throw new IllegalArgumentException("Please upload a PDF file");
        }

        String submittedName = cvPart.getSubmittedFileName();
        if (submittedName == null || !submittedName.toLowerCase().endsWith(".pdf")) {
            throw new IllegalArgumentException("Only PDF is supported");
        }

        Path cvDir = Paths.get("data", "cv");
        Files.createDirectories(cvDir);

        String fileName = sessionUser.userId + ".pdf";
        Path target = cvDir.resolve(fileName);
        try {
            cvPart.write(target.toString());
        } catch (Exception e) {
            throw new IllegalArgumentException("Failed to save CV: " + e.getMessage());
        }

        String relative = "cv/" + fileName;
        userService.uploadCv(sessionUser.userId, relative);
        response.sendRedirect(request.getContextPath() + "/user/profile?cv=1");
    }

    private static ApplicantProfile parseApplicantProfile(String profileJson) {
        if (profileJson == null || profileJson.trim().isEmpty()) {
            return new ApplicantProfile("", "");
        }
        try {
            return GsonUtil.fromJson(profileJson, ApplicantProfile.class);
        } catch (Exception e) {
            return new ApplicantProfile("", "");
        }
    }

    private static List<String> roleToRoles(String role) {
        if (role == null || role.trim().isEmpty()) {
            return List.of("TA");
        }
        String r = role.trim().toUpperCase();
        if ("ADMIN".equals(r) || "ADMINISTRATOR".equals(r)) {
            return List.of("ADMIN");
        }
        if ("MO".equals(r)) {
            return List.of("MO");
        }
        return List.of("TA");
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
