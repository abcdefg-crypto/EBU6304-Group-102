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

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet(urlPatterns = {"/user/register", "/user/profile", "/user/cv/upload", "/user/cv/delete"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024,  // 10MB
        maxRequestSize = 20 * 1024 * 1024
)
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
            switch (servletPath) {
                case "/user/register" -> doRegister(request, response);
                case "/user/profile" -> doProfilePost(request, response);
                case "/user/cv/upload" -> doCvUpload(request, response);
                case "/user/cv/delete" -> doCvDelete(request, response);
                default -> response.sendError(404);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            String target = "/user/register".equals(servletPath) ? "/register.jsp" : "/profile.jsp";
            request.getRequestDispatcher(target).forward(request, response);
        }
    }

    // doProfilePost 重构：处理邮箱和电话的修改 (Story 4)
    private void doProfilePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        User existing = userService.findById(userId);

        // 获取参数
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String phoneNumber = request.getParameter("phoneNumber"); // 获取新字段
        String skills = request.getParameter("skills");
        String selfIntroduction = request.getParameter("selfIntroduction");

        // 封装 Profile 逻辑
        ApplicantProfile profile = new ApplicantProfile(name, studentId, phoneNumber, skills, selfIntroduction);
        existing.setEmail(email);
        existing.setProfile(GsonUtil.toJson(profile));

        userService.updateProfile(existing);
        response.sendRedirect(request.getContextPath() + "/user/profile?updated=1");
    }

    private void doCvUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");

        Part cvPart = request.getPart("cv");
        if (cvPart == null || cvPart.getSize() <= 0) {
            throw new IllegalArgumentException("Please select a file to upload");
        }

        String submittedName = cvPart.getSubmittedFileName();
        if (submittedName == null || !submittedName.toLowerCase().endsWith(".pdf")) {
            throw new IllegalArgumentException("Only PDF format is supported");
        }

        String fileName = userId + ".pdf";
        Path cvDir = Paths.get("data", "cv").toAbsolutePath().normalize();
        Files.createDirectories(cvDir);
        Path targetFile = cvDir.resolve(fileName);
        try (var input = cvPart.getInputStream()) {
            Files.copy(input, targetFile, StandardCopyOption.REPLACE_EXISTING);
        }

        // 保存相对路径，方便下载控制器在 data 目录内定位
        String relativePath = "cv/" + fileName;
        userService.uploadCv(userId, relativePath);
        response.sendRedirect(request.getContextPath() + "/user/profile?cv=1");
    }

    private void doCvDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        User existing = userService.findById(userId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        String cvPath = existing.getCvPath();
        if (cvPath != null && !cvPath.trim().isEmpty()) {
            Path filePath = Paths.get("data").toAbsolutePath().normalize().resolve(cvPath).normalize();
            if (filePath.startsWith(Paths.get("data").toAbsolutePath().normalize())) {
                Files.deleteIfExists(filePath);
            }
        }

        userService.uploadCv(userId, null);
        response.sendRedirect(request.getContextPath() + "/user/profile?cvDeleted=1");
    }

    private void doRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String role = request.getParameter("role");
        String phoneNumber = request.getParameter("phoneNumber");
        String skills = request.getParameter("skills");
        String selfIntroduction = request.getParameter("selfIntroduction");

        ApplicantProfile profile = new ApplicantProfile(name, studentId, phoneNumber, skills, selfIntroduction);

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
