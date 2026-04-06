package com.bupt.is.controller;

import com.bupt.is.model.Applicant;
import com.bupt.is.service.ApplicantService;
import com.bupt.is.service.impl.ApplicantServiceImpl;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

/**
 * 申请者请求处理类：整合列表查询、简历查看所有请求处理逻辑（无接口，直接实现）
 */
public class ApplicantController {
    // 依赖Service实现类处理业务逻辑
    private final ApplicantService applicantService = new ApplicantServiceImpl();

    /**
     * 处理申请者列表查询请求
     * 
     * @param request  HTTP请求对象
     * @param response HTTP响应对象
     * @throws IOException 流操作异常
     */
    public void handleApplicantListRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // 1. 解析请求参数（仅提取，无业务逻辑）
        String jobPostingId = request.getParameter("jobPostingId");

        try {
            // 2. 调用Service获取数据（业务逻辑由Service层处理）
            List<Applicant> applicants = applicantService.getApplicantsByJobId(jobPostingId);

            // 3. 封装数据并跳转至列表页面
            request.setAttribute("applicants", applicants);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/applicantList.jsp");
            dispatcher.forward(request, response);
        } catch (IllegalArgumentException | ServletException e) {
            // 4. 异常处理：跳转错误页
            request.setAttribute("errorMsg", e.getMessage());
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * 处理申请者简历查看请求
     * 
     * @param request  HTTP请求对象
     * @param response HTTP响应对象
     * @throws IOException 流操作异常
     */
    public void handleApplicantCvRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. 解析请求参数
        String applicantId = request.getParameter("applicantId");

        try {
            // 2. 调用Service获取申请者信息
            Applicant applicant = applicantService.getApplicantById(applicantId);
            if (applicant == null) {
                request.setAttribute("errorMsg", "申请者不存在");
                request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
                return;
            }

            // 3. 读取并输出简历文件（仅IO转发，无业务逻辑）
            File cvFile = new File(applicant.getCvFilePath());
            if (!cvFile.exists()) {
                request.setAttribute("errorMsg", "简历文件不存在");
                request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
                return;
            }

            // 设置响应头，保证浏览器正确解析PDF格式简历
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + applicant.getName() + "_CV.pdf\"");

            // 流式输出文件（避免大文件导致内存溢出）
            try (FileInputStream fis = new FileInputStream(cvFile);
                    OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, len);
                }
            }
        } catch (IllegalArgumentException | ServletException e) {
            // 异常处理：跳转错误页
            request.setAttribute("errorMsg", e.getMessage());
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
}