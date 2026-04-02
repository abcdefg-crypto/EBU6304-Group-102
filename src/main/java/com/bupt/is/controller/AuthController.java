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

@WebServlet(urlPatterns = {"/auth/login", "/auth/logout"})
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
        if ("/auth/logout".equals(servletPath)) {
            doLogout(request, response);
            return;
        }
        response.sendError(404);
    }

    private void doLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authService.login(username, password);
        if (user == null) {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String primaryRole = pickPrimaryRole(user);
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getId());
        session.setAttribute("role", primaryRole);
        session.setAttribute("username", user.getUsername());

        // Redirect to a role-specific entry.
        if ("TA".equals(primaryRole)) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        } else if ("MO".equals(primaryRole)) {
            response.sendRedirect(request.getContextPath() + "/jobs/post");
        } else {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
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
}
