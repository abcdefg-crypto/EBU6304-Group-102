package dev.web;

import dev.service.*;
import dev.auth.SessionManager;
import dev.model.*;
import dev.exception.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class AuthServlet extends HttpServlet {
    private AuthService authService;

    public AuthServlet(AuthService authService) { this.authService = authService; }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        resp.setContentType("application/json; charset=UTF-8");
        // TODO: 解析 JSON 请求体并分发
    }
}