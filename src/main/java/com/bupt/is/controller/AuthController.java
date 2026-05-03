package com.bupt.is.controller;

import com.bupt.is.model.User;
import com.bupt.is.service.AuthService;
import com.bupt.is.service.impl.AuthServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/auth/login", "/auth/logout", "/auth/select-role"})
public class AuthController extends HttpServlet {

    private final AuthService authService = new AuthServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/auth/login".equals(servletPath)) {
            doLogin(request, response);
            return;
        }
        response.sendError(404);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/auth/select-role".equals(servletPath)) {
            doSelectRole(request, response);
            return;
        }
        if ("/auth/logout".equals(servletPath)) {
            doLogout(request, response);
            return;
        }
        response.sendError(404);
    }

    private void doLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession(true);
        String selectedRole = (String) session.getAttribute("selectedRole");

        if (selectedRole == null || selectedRole.trim().isEmpty()) {
            request.setAttribute("error", "Please select a login role first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = authService.login(username, password);
        if (user == null) {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String primaryRole = pickPrimaryRole(user);
        if (!selectedRole.equals(primaryRole)) {
            request.setAttribute("error", "Role mismatch: selected role is " + selectedRole + ". Please use an account with the same role.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        session.setAttribute("userId", user.getId());
        session.setAttribute("role", primaryRole);
        session.setAttribute("username", user.getUsername());

        if ("ADMIN".equals(primaryRole)) {
            response.sendRedirect(request.getContextPath() + "/admin/workload");
        } else {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }

    private void doSelectRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String role = request.getParameter("role");
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/role_select.jsp");
            return;
        }

        String normalizedRole = normalizeRole(role);
        if (normalizedRole == null) {
            response.sendRedirect(request.getContextPath() + "/role_select.jsp");
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("selectedRole", normalizedRole);
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    private void doLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/");
    }

    private static String pickPrimaryRole(User user) {
        if (user.getRoles() == null || user.getRoles().isEmpty()) {
            return "TA";
        }
        if (user.hasRole("TA")) {
            return "TA";
        }
        if (user.hasRole("MO")) {
            return "MO";
        }
        if (user.hasRole("ADMIN") || user.hasRole("ADMINISTRATOR")) {
            return "ADMIN";
        }
        return user.getRoles().get(0);
    }

    private static String normalizeRole(String role) {
        String r = role.trim().toUpperCase();
        if ("TA".equals(r)) {
            return "TA";
        }
        if ("MO".equals(r)) {
            return "MO";
        }
        if ("ADMIN".equals(r) || "ADMINISTRATOR".equals(r)) {
            return "ADMIN";
        }
        return null;
    }
}
