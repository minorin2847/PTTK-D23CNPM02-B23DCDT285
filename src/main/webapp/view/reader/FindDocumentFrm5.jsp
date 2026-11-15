<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, dao.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Reader5 reader = (Reader5) session.getAttribute("reader");
    if (reader == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }

    // inoutQueryType : Select, inQuery : TextField
    String queryType = request.getParameter("queryType");
    if (queryType == null) queryType = "name";
    String query = request.getParameter("query");

    // subFind pressed -> DocumentDAO5.searchDocuments()
    if (query != null && !query.trim().isEmpty()) {
        Document5[] listDocuments;
        try (DocumentDAO5 dao = new DocumentDAO5()) {
            listDocuments = dao.searchDocuments(queryType, query.trim());
        }
        // kept in session so DocumentInfoFrm5 can show the selected document
        session.setAttribute("listDocuments", listDocuments);
        request.setAttribute("listDocuments", listDocuments);
        request.setAttribute("searched", Boolean.TRUE);
    }
    request.setAttribute("queryType", queryType);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm tài liệu - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page">
    <div class="titlebar">
        <span>Tìm thông tin tài liệu - Tìm tài liệu</span>
        <span><c:out value="${sessionScope.reader.name}"/>
            <a href="ReaderMainFrm5.jsp">Trang chủ</a></span>
    </div>
    <div class="content">
        <form method="get" action="FindDocumentFrm5.jsp" class="row">
            <select name="queryType" aria-label="Cách tìm">
                <option value="name"      ${queryType == 'name'      ? 'selected' : ''}>Tìm theo tên</option>
                <option value="author"    ${queryType == 'author'    ? 'selected' : ''}>Tìm theo tác giả</option>
                <option value="publisher" ${queryType == 'publisher' ? 'selected' : ''}>Tìm theo nhà xuất bản</option>
                <option value="genre"     ${queryType == 'genre'     ? 'selected' : ''}>Tìm theo thể loại</option>
            </select>
            <input class="grow" type="text" name="query" required aria-label="Từ khóa"
                   value="<c:out value='${param.query}'/>">
            <button class="btn" type="submit">Tìm kiếm</button>
        </form>

        <c:choose>
            <c:when test="${empty searched}">
                <div class="placeholder">Bắt đầu tìm kiếm để xem kết quả</div>
            </c:when>
            <c:when test="${empty listDocuments}">
                <div class="placeholder">Không tìm thấy tài liệu phù hợp</div>
            </c:when>
            <c:otherwise>
                <%-- outsubDocuments : Table — click a row to see details --%>
                <div class="table-wrap">
                    <table>
                        <thead>
                        <tr>
                            <th>ID</th><th>Mã</th><th>Loại tài liệu</th><th>Tên tài liệu</th>
                            <th>Tác giả</th><th>Nhà xuất bản</th><th>Năm xuất bản</th><th>Thể loại</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="d" items="${listDocuments}" varStatus="s">
                            <c:url var="detailUrl" value="DocumentInfoFrm5.jsp">
                                <c:param name="index" value="${s.index}"/>
                                <c:param name="queryType" value="${queryType}"/>
                                <c:param name="query" value="${param.query}"/>
                            </c:url>
                            <tr class="clickable" onclick="location.href='${detailUrl}'">
                                <td>${s.count}</td>
                                <td><a href="${detailUrl}"><c:out value="${d.code}"/></a></td>
                                <td><c:out value="${d.type}"/></td>
                                <td><c:out value="${d.name}"/></td>
                                <td><c:out value="${d.author}"/></td>
                                <td><c:out value="${d.publisher}"/></td>
                                <td><c:out value="${d.publishedYear}"/></td>
                                <td><c:out value="${d.genre}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
