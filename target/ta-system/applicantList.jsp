<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html>

        <head>
            <title>Job Applicant List</title>
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
            <h2>Job Applicant List</h2>

            <table>
                <tr>
                    <th>Applicant ID</th>
                    <th>Name</th>
                    <th>Profile</th>
                    <th>Action</th>
                </tr>
                <c:choose>
                    <%-- Message when no applicants --%>
                        <c:when test="${empty applicants}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: #666;">
                                    No applicants for this job
                                </td>
                            </tr>
                        </c:when>
                        <%-- Iterate and display applicants --%>
                            <c:otherwise>
                                <c:forEach var="applicant" items="${applicants}">
                                    <tr>
                                        <td>${applicant.applicantId}</td>
                                        <td>${applicant.name}</td>
                                        <td>${applicant.profile}</td>
                                        <td>
                                            <%-- CV link handled by handleApplicantCvRequest --%>
                                                <a href="${pageContext.request.contextPath}/applicants/cv?applicantId=${applicant.applicantId}"
                                                    target="_blank">
                                                    View CV
                                                </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                </c:choose>
            </table>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/jobPostings">Back to Job List</a>
            </div>
        </body>

        </html>