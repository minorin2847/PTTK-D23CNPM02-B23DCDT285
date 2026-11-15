<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, dao.*, java.util.Base64" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Librarian5 librarian = (Librarian5) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }

    // inReaderCardID + subSearch -> ReaderCardDAO5.getReaderCard()
    String cardIdText = request.getParameter("readerCardId");
    if (cardIdText != null) {
        session.removeAttribute("readerCard");
        session.removeAttribute("slip");          // a new reader starts a new slip
        try {
            int cardId = Integer.parseInt(cardIdText.trim());
            ReaderCard5 readerCard;
            try (ReaderCardDAO5 dao = new ReaderCardDAO5()) {
                readerCard = dao.getReaderCard(cardId);
            }
            if (readerCard == null) {
                request.setAttribute("error", "Không tìm thấy thẻ người đọc có mã " + cardId + ".");
            } else {
                session.setAttribute("readerCard", readerCard);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã thẻ người đọc phải là số.");
        }
    }

    ReaderCard5 readerCard = (ReaderCard5) session.getAttribute("readerCard");
    if (readerCard != null && readerCard.getImage() != null && readerCard.getImage().length > 0) {
        request.setAttribute("imageData", Base64.getEncoder().encodeToString(readerCard.getImage()));
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quét thẻ người đọc - LibMan</title>
    <link rel="stylesheet" href="<%= ctx %>/view/common/style.css">
</head>
<body>
<div class="page narrow">
    <div class="titlebar">
        <span>Cho mượn tài liệu - Quét thẻ người đọc</span>
        <span><c:out value="${sessionScope.librarian.name}"/>
            <a href="LibrarianMainFrm5.jsp">Trang chủ</a></span>
    </div>
    <div class="content">
        <form method="get" action="GetReaderCardInfoFrm5.jsp">
            <label for="readerCardId">Quét hoặc điền mã thẻ người đọc</label>
            <div class="row">
                <input class="grow" type="text" id="readerCardId" name="readerCardId" required autofocus
                       inputmode="numeric" value="<c:out value='${param.readerCardId}'/>">
                <button class="btn" type="submit">Tìm kiếm</button>
            </div>
        </form>

        <c:if test="${not empty error}">
            <div class="msg error"><c:out value="${error}"/></div>
        </c:if>

        <c:set var="card" value="${sessionScope.readerCard}"/>
        <c:choose>
            <c:when test="${empty card}">
                <div class="placeholder">Điền mã thẻ người đọc để tiếp tục</div>
            </c:when>
            <c:otherwise>
                <div class="card">
                    <c:choose>
                        <c:when test="${not empty imageData}">
                            <img class="photo" src="data:image/jpeg;base64,${imageData}" alt="Ảnh thẻ">
                        </c:when>
                        <c:otherwise><div class="photo" role="img" aria-label="Chưa có ảnh"></div></c:otherwise>
                    </c:choose>
                    <div class="info">
                        <p>ID: <c:out value="${card.id}"/></p>
                        <p>Tên: <c:out value="${card.reader.name}"/></p>
                        <p>Mã SV: <c:out value="${card.reader.studentid}"/></p>
                        <p>Trạng thái:
                            <c:choose>
                                <c:when test="${card.active}"><span class="ok-text">Có thể mượn</span></c:when>
                                <c:otherwise><span class="bad-text">Không thể mượn (<c:out value="${card.status}"/>)</span></c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- subNext : link — only enabled for an active card --%>
        <div class="center">
            <a class="btn ${not empty card and card.active ? '' : 'disabled'}" href="LendDocumentFrm5.jsp">Tiếp tục</a>
        </div>
    </div>
</div>
</body>
</html>
