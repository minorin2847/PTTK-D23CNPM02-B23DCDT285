<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi - LibMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/common/style.css">
</head>
<body>
<div class="page">
    <div class="titlebar"><span>LibMan - Lỗi</span></div>
    <div class="content center">
        <h2>Đã xảy ra lỗi</h2>
        <p class="msg error">
            <c:out value="${pageContext.exception != null ? pageContext.exception.message : 'Không xác định'}"/>
        </p>
        <a class="btn" href="${pageContext.request.contextPath}/view/user/LoginFrm5.jsp">Về trang đăng nhập</a>
    </div>
</div>
</body>
</html>
