<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="model.*, dao.*, java.util.Calendar, java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%!
    /** Default loan period for each borrowed document. */
    private static final int LOAN_DAYS = 14;
%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Librarian5 librarian = (Librarian5) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }
    ReaderCard5 readerCard = (ReaderCard5) session.getAttribute("readerCard");
    if (readerCard == null || !readerCard.isActive()) {
        response.sendRedirect("GetReaderCardInfoFrm5.jsp");
        return;
    }

    // The slip being built is kept in session until it is saved.
    LoanSlip5 slip = (LoanSlip5) session.getAttribute("slip");
    if (slip == null || slip.getReader() == null || slip.getReader().getId() != readerCard.getId()) {
        slip = new LoanSlip5();
        slip.setLoanDate(new Date());
        slip.setReader(readerCard);
        session.setAttribute("slip", slip);
    }

    String action = request.getParameter("action");
    if ("POST".equalsIgnoreCase(request.getMethod()) && action != null) {
        switch (action) {
            case "search": {
                // inDocumentID + subSearch -> DocumentItemDAO5.getDocument()
                String idText = request.getParameter("documentItemId");
                try {
                    int itemId = Integer.parseInt(idText == null ? "" : idText.trim());
                    DocumentItem5 item;
                    try (DocumentItemDAO5 dao = new DocumentItemDAO5()) {
                        item = dao.getDocument(itemId);
                    }
                    if (item == null) {
                        request.setAttribute("error", "Không tìm thấy tài liệu có mã " + itemId + ".");
                    } else if (slip.containsItem(itemId)) {
                        request.setAttribute("error", "Tài liệu " + itemId + " đã có trong phiếu mượn.");
                    } else if (!item.isAvailable()) {
                        request.setAttribute("error", "Tài liệu " + itemId + " hiện không thể cho mượn (đang được mượn).");
                    } else {
                        Calendar due = Calendar.getInstance();
                        due.setTime(slip.getLoanDate());
                        due.add(Calendar.DAY_OF_MONTH, LOAN_DAYS);

                        LoanDocumentItem5 line = new LoanDocumentItem5();
                        line.setDocument(item);
                        line.setDueDate(due.getTime());
                        line.setSlip(slip);
                        slip.getDocuments().add(line);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Mã tài liệu phải là số.");
                }
                break;
            }
            case "delete": {
                try {
                    int index = Integer.parseInt(request.getParameter("index"));
                    if (index >= 0 && index < slip.getDocuments().size()) {
                        slip.getDocuments().remove(index);
                    }
                } catch (NumberFormatException ignored) {
                    // nothing to delete
                }
                break;
            }
            default:
                break;
        }
    }
    request.setAttribute("slip", slip);
    request.setAttribute("today", new Date());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quét mã tài liệu - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page">
    <div class="titlebar">
        <span>Cho mượn tài liệu - Quét mã tài liệu</span>
        <span><c:out value="${sessionScope.librarian.name}"/></span>
    </div>
    <div class="content">
        <div class="header-info">
            <div>
                <p>Tên: <c:out value="${slip.reader.reader.name}"/></p>
                <p>ID: <c:out value="${slip.reader.id}"/></p>
                <p>Ngày: <fmt:formatDate value="${slip.loanDate}" pattern="dd/MM/yyyy"/></p>
                <p>Thủ thư: <c:out value="${sessionScope.librarian.name}"/></p>
            </div>
            <strong>PHIẾU MƯỢN TÀI LIỆU</strong>
        </div>

        <form method="post" action="LendDocumentFrm5.jsp">
            <input type="hidden" name="action" value="search">
            <label for="documentItemId">Quét hoặc điền mã tài liệu cho mượn</label>
            <div class="row">
                <input class="grow" type="text" id="documentItemId" name="documentItemId" required autofocus
                       inputmode="numeric">
                <button class="btn" type="submit">Tìm kiếm</button>
            </div>
        </form>

        <c:if test="${not empty error}">
            <div class="msg error"><c:out value="${error}"/></div>
        </c:if>

        <c:choose>
            <c:when test="${empty slip.documents}">
                <div class="placeholder">Nhập mã tài liệu để tiếp tục</div>
            </c:when>
            <c:otherwise>
                <%-- outsubLendDocuments : Table --%>
                <div class="table-wrap">
                    <table>
                        <thead>
                        <tr>
                            <th>ID</th><th>Mã tài liệu</th><th>Mã ISBN</th><th>Loại tài liệu</th><th>Tên</th>
                            <th>Tác giả</th><th>Nhà xuất bản</th><th>Năm xuất bản</th><th>Thể loại</th>
                            <th>Ngày hẹn trả</th><th>Hoạt động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="line" items="${slip.documents}" varStatus="s">
                            <tr>
                                <td>${s.count}</td>
                                <td><c:out value="${line.document.id}"/></td>
                                <td><c:out value="${line.document.document.code}"/></td>
                                <td><c:out value="${line.document.document.type}"/></td>
                                <td><c:out value="${line.document.document.name}"/></td>
                                <td><c:out value="${line.document.document.author}"/></td>
                                <td><c:out value="${line.document.document.publisher}"/></td>
                                <td><c:out value="${line.document.document.publishedYear}"/></td>
                                <td><c:out value="${line.document.document.genre}"/></td>
                                <td class="due"><fmt:formatDate value="${line.dueDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <form method="post" action="LendDocumentFrm5.jsp">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="index" value="${s.index}">
                                        <button class="btn link" type="submit">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="actions">
            <%-- subBack : link --%>
            <a class="btn" href="GetReaderCardInfoFrm5.jsp">Quay lại</a>
            <%-- subSave : link -> doLoanSlip.jsp -> LoanSlipDAO5.saveLoanSlip() --%>
            <form method="post" action="doLoanSlip.jsp">
                <button class="btn" type="submit" ${empty slip.documents ? 'disabled' : ''}>Hoàn tất</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
