<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 삭제</title>
</head>
<body>
<%
    String postID = request.getParameter("postID");
    String userID = (String) request.getSession().getAttribute("id");

    if (userID == null || userID.equals("")) {
        out.println("<script>alert('로그인 후 이용 가능한 기능입니다.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sumate?useUnicode=true&characterEncoding=UTF-8", "root", "1234");


        // 게시글 삭제 SQL
        String sql = "DELETE FROM posts WHERE id = ? AND userID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, postID);
        pstmt.setString(2, userID);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.println("<script>alert('게시글이 성공적으로 삭제되었습니다.'); location.href='roomMate.jsp';</script>");
        } else {
            out.println("<script>alert('게시글 삭제에 실패했습니다.'); history.back();</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다. 다시 시도해주세요.'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
</body>
</html>
