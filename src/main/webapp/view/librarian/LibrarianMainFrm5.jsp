<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String ctx = request.getContextPath();
    Librarian5 librarian = (Librarian5) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }
    // Coming back to the main page ends any lending flow in progress.
    session.removeAttribute("readerCard");
    session.removeAttribute("slip");
    session.removeAttribute("savedSlip");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ thủ thư - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page narrow">
    <div class="titlebar">
        <span>Trang chủ thủ thư</span>
        <span><c:out value="${sessionScope.librarian.name}"/>
            <a href="<%= ctx %>/view/user/doLogout.jsp">Đăng xuất</a></span>
    </div>
    <div class="content center">
        <h2>Trang chủ thủ thư</h2>
        <%-- subLendDocument : link --%>
        <a class="btn" href="GetReaderCardInfoFrm5.jsp">Cho mượn tài liệu</a>
    </div>
</div>
</body>
</html>
