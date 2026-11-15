<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, java.util.Base64" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String ctx = request.getContextPath();
    Reader5 reader = (Reader5) session.getAttribute("reader");
    if (reader == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }

    // The selected document comes from the list FindDocumentFrm5 just displayed.
    Document5[] listDocuments = (Document5[]) session.getAttribute("listDocuments");
    Document5 document = null;
    try {
        int index = Integer.parseInt(request.getParameter("index"));
        if (listDocuments != null && index >= 0 && index < listDocuments.length) {
            document = listDocuments[index];
        }
    } catch (NumberFormatException ignored) {
        // falls through to the redirect below
    }
    if (document == null) {
        response.sendRedirect("FindDocumentFrm5.jsp");
        return;
    }
    request.setAttribute("document", document);
    if (document.getImage() != null && document.getImage().length > 0) {
        request.setAttribute("imageData", Base64.getEncoder().encodeToString(document.getImage()));
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết tài liệu - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page">
    <div class="titlebar">
        <span>Tìm thông tin tài liệu - Chi tiết tài liệu</span>
        <span><c:out value="${sessionScope.reader.name}"/></span>
    </div>
    <div class="content">
        <div class="card">
            <%-- outImage --%>
            <c:choose>
                <c:when test="${not empty imageData}">
                    <img class="photo big" src="data:image/jpeg;base64,${imageData}" alt="Ảnh tài liệu">
                </c:when>
                <c:otherwise><div class="photo big" role="img" aria-label="Chưa có ảnh"></div></c:otherwise>
            </c:choose>
            <div class="info">
                <p>Mã tài liệu: <c:out value="${document.code}"/></p>
                <p>Loại tài liệu: <c:out value="${document.type}"/></p>
                <p>Tên tài liệu: <c:out value="${document.name}"/></p>
                <p>Tác giả: <c:out value="${document.author}"/></p>
                <p>Nhà xuất bản: <c:out value="${document.publisher}"/></p>
                <p>Năm xuất bản: <c:out value="${document.publishedYear}"/></p>
                <p>Thể loại: <c:out value="${document.genre}"/></p>
                <p>Tóm tắt nội dung:<br><c:out value="${document.description}"/></p>
            </div>
        </div>
        <%-- subBack : link — back to the same search results --%>
        <c:url var="backUrl" value="FindDocumentFrm5.jsp">
            <c:param name="queryType" value="${param.queryType}"/>
            <c:param name="query" value="${param.query}"/>
        </c:url>
        <div class="center"><a class="btn" href="${backUrl}">Quay lại</a></div>
    </div>
</div>
</body>
</html>
