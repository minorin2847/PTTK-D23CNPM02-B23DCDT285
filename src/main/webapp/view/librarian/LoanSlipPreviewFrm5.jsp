<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String ctx = request.getContextPath();
    Librarian5 librarian = (Librarian5) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }
    // slip : LoanSlip5 — the slip LoanSlipDAO5 has just saved
    LoanSlip5 slip = (LoanSlip5) session.getAttribute("savedSlip");
    if (slip == null) {
        response.sendRedirect("LibrarianMainFrm5.jsp");
        return;
    }
    request.setAttribute("slip", slip);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>In phiếu mượn - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page">
    <div class="titlebar no-print">
        <span>Cho mượn tài liệu - In phiếu mượn</span>
        <span><c:out value="${sessionScope.librarian.name}"/></span>
    </div>
    <div class="content">
        <h2 class="center no-print">XEM TRƯỚC PHIẾU MƯỢN</h2>

        <div class="slip">
            <h3>PHIẾU MƯỢN TÀI LIỆU</h3>
            <p>Số phiếu: <c:out value="${slip.id}"/></p>
            <p>Tên bạn đọc: <c:out value="${slip.reader.reader.name}"/></p>
            <p>Mã thẻ bạn đọc: <c:out value="${slip.reader.id}"/></p>
            <p>Ngày mượn: <fmt:formatDate value="${slip.loanDate}" pattern="dd/MM/yyyy"/></p>
            <p>Thủ thư: <c:out value="${sessionScope.librarian.name}"/></p>

            <p>Các tài liệu đã mượn:</p>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr><th>ID</th><th>Mã tài liệu</th><th>Mã ISBN</th><th>Tên</th><th>Tác giả</th><th>Ngày hẹn trả</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="line" items="${slip.documents}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td><c:out value="${line.document.id}"/></td>
                            <td><c:out value="${line.document.document.code}"/></td>
                            <td><c:out value="${line.document.document.name}"/></td>
                            <td><c:out value="${line.document.document.author}"/></td>
                            <td><strong><fmt:formatDate value="${line.dueDate}" pattern="dd/MM/yyyy"/></strong></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <p class="note">Sau khi mượn tài liệu, bạn đọc cần đảm bảo trả tài liệu đúng hạn, giữ gìn tài liệu cẩn thận.
                Thư viện sẽ đưa ra mức phạt theo quy định nếu bạn đọc trả sách muộn hạn hoặc tài liệu bị hư hỏng
                hay thất lạc. Thư viện sẽ tước thẻ bạn đọc nếu vi phạm nhiều lần hoặc tài liệu có giá trị cao.</p>
        </div>

        <div class="actions no-print">
            <%-- subBack : link — back to LendDocumentFrm5 (state diagram, module 2) --%>
            <a class="btn" href="LendDocumentFrm5.jsp">Quay lại</a>
            <%-- subPrint : link — print, then return to LibrarianMainFrm5 --%>
            <button class="btn" type="button"
                    onclick="window.print(); location.href='LibrarianMainFrm5.jsp';">In phiếu</button>
        </div>
    </div>
</div>
</body>
</html>
