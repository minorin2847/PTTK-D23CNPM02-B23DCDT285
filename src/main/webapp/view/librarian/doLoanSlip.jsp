<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, dao.*" %>
<%--
    doLoanSlip.jsp (detail class diagram, module 2): receives subSave from LendDocumentFrm5,
    calls LoanSlipDAO5.saveLoanSlip(slip) and, if saved, shows LoanSlipPreviewFrm5.
--%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Librarian5 librarian = (Librarian5) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(ctx + "/view/user/LoginFrm5.jsp");
        return;
    }

    // slip : LoanSlip5 — the slip built on LendDocumentFrm5
    LoanSlip5 slip = (LoanSlip5) session.getAttribute("slip");
    if (slip == null || !"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("LendDocumentFrm5.jsp");
        return;
    }
    if (slip.getDocuments().isEmpty()) {
        request.setAttribute("error", "Phiếu mượn chưa có tài liệu nào.");
        request.getRequestDispatcher("LendDocumentFrm5.jsp").forward(request, response);
        return;
    }

    boolean saved;
    try (LoanSlipDAO5 dao = new LoanSlipDAO5()) {
        saved = dao.saveLoanSlip(slip);
    }
    if (!saved) {
        request.setAttribute("error",
                "Không lưu được phiếu: có tài liệu vừa được cho mượn ở nơi khác. Hãy xóa và quét lại.");
        request.getRequestDispatcher("LendDocumentFrm5.jsp").forward(request, response);
        return;
    }

    // The reader card stays in session so "Quay lại" on the preview returns to LendDocumentFrm5
    // (state diagram, module 2) with a new, empty slip for the same reader.
    session.setAttribute("savedSlip", slip);
    session.removeAttribute("slip");
    response.sendRedirect("LoanSlipPreviewFrm5.jsp");
%>
