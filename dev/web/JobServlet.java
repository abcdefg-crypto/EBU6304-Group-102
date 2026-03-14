package dev.web;

import dev.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class JobServlet extends HttpServlet {
    private JobPostingService jobPostingService; // 假定存在包装服务
    public JobServlet(JobPostingService jobPostingService) { this.jobPostingService = jobPostingService; }
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { /* TODO */ }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { /* TODO */ }
}
