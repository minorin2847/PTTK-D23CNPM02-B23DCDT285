<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, dao.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User5 user = null;
        if (username != null && password != null) {
            try (UserDAO5 dao = new UserDAO5()) {
                user = dao.checkLogin(username.trim(), password);
            }
        }
        if (user instanceof Reader5) {
            session.invalidate();
            request.getSession(true).setAttribute("reader", user);
            response.sendRedirect(ctx + "/view/reader/ReaderMainFrm5.jsp");
            return;
        } else if (user instanceof Librarian5) {
            session.invalidate();
            request.getSession(true).setAttribute("librarian", user);
            response.sendRedirect(ctx + "/view/librarian/LibrarianMainFrm5.jsp");
            return;
        } else if (user != null) {
            request.setAttribute("error", "Tài khoản này không có chức năng trong hai module đã cài đặt.");
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu.");
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page narrow">
    <div class="titlebar"><span>LibMan - Đăng nhập</span></div>
    <div class="content">
        <c:if test="${not empty error}">
            <div class="msg error"><c:out value="${error}"/></div>
        </c:if>
        <form method="post" action="LoginFrm5.jsp">
            <div class="row">
                <div class="grow">
                    <label for="username">Tên đăng nhập</label>
                    <input class="grow" type="text" id="username" name="username" required
                           value="<c:out value='${param.username}'/>">
                </div>
            </div>
            <div class="row">
                <div class="grow">
                    <label for="password">Mật khẩu</label>
                    <input class="grow" type="password" id="password" name="password" required>
                </div>
            </div>
            <div class="center"><button class="btn" type="submit">Đăng nhập</button></div>
        </form>
    </div>
</div>
</body>
</html>
