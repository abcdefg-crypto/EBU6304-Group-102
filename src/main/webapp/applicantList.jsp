<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html>

        <head>
            <title>岗位申请者列表</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h2 {
                    text-align: center;
                    color: #333;
                }

                table {
                    border-collapse: collapse;
                    width: 80%;
                    margin: 20px auto;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 10px;
                    text-align: left;
                }

                th {
                    background-color: #f5f5f5;
                    color: #333;
                }

                a {
                    color: #0066cc;
                    text-decoration: none;
                }

                a:hover {
                    text-decoration: underline;
                }

                .back-link {
                    text-align: center;
                    margin-top: 20px;
                }
            </style>
        </head>

        <body>
            <h2>岗位申请者列表</h2>

            <table>
                <tr>
                    <th>申请者ID</th>
                    <th>姓名</th>
                    <th>个人简介</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <%-- 无申请者时的提示 --%>
                        <c:when test="${empty applicants}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: #666;">
                                    该岗位暂无申请者
                                </td>
                            </tr>
                        </c:when>
                        <%-- 有申请者时遍历显示 --%>
                            <c:otherwise>
                                <c:forEach var="applicant" items="${applicants}">
                                    <tr>
                                        <td>${applicant.applicantId}</td>
                                        <td>${applicant.name}</td>
                                        <td>${applicant.profile}</td>
                                        <td>
                                            <%-- 查看简历链接，对应Controller的handleApplicantCvRequest方法 --%>
                                                <a href="${pageContext.request.contextPath}/applicants/cv?applicantId=${applicant.applicantId}"
                                                    target="_blank">
                                                    查看简历
                                                </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                </c:choose>
            </table>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/jobPostings">返回岗位列表</a>
            </div>
        </body>

        </html>