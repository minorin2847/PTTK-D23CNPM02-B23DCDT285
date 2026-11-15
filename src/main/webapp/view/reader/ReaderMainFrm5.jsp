<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String ctx = request.getContextPath();
    Reader5 reader = (Reader5) session.getAttribute("reader");
    if (reader == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ người đọc - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page narrow">
    <div class="titlebar">
        <span>Trang chủ người đọc</span>
        <span><c:out value="${sessionScope.reader.name}"/>
            <a href="<%= ctx %>/view/user/doLogout.jsp">Đăng xuất</a></span>
    </div>
    <div class="content center">
        <h2>Trang chủ người đọc</h2>
        <%-- subFindDocument : link --%>
        <a class="btn" href="FindDocumentFrm5.jsp">Tìm thông tin tài liệu</a>
    </div>
</div>
</body>
</html>
