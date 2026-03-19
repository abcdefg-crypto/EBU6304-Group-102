package com.bupt.is.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(urlPatterns = {"/files/cv"})
public class CvDownloadController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cvPath = request.getParameter("cvPath");
        if (cvPath == null || cvPath.trim().isEmpty()) {
            response.sendError(400);
            return;
        }
        if (cvPath.contains("..") || cvPath.startsWith("/") || cvPath.startsWith("\\")) {
            response.sendError(403);
            return;
        }

        Path baseDir = Paths.get("data").toAbsolutePath().normalize();
        Path file = baseDir.resolve(cvPath).normalize();
        if (!file.startsWith(baseDir)) {
            response.sendError(403);
            return;
        }
        if (!Files.exists(file)) {
            response.sendError(404);
            return;
        }

        byte[] bytes = Files.readAllBytes(file);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getFileName() + "\"");
        response.getOutputStream().write(bytes);
    }
}

