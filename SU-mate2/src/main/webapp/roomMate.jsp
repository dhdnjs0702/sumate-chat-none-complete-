<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="javax.servlet.http.*" %> <!-- HttpSession 관련 객체 import -->

<%
    // 로그인 상태 확인
    String userID = (String) session.getAttribute("id");

    if (userID == null) {
%>
        <script type="text/javascript">
            alert("로그인 후 이용 가능한 페이지입니다.");
            window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        </script>
<%
        return; // JSP 페이지 실행 종료
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>룸메이트 게시판</title>
    <link rel="stylesheet" href="/SU_FM/css/main_styles.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
<div class="main-container">
    <%@ include file="header_login.jsp" %> <!-- 헤더 부분 -->

    <!-- 새 글 작성 버튼 -->
    <div class="container mt-4">
        <a class="btn btn-primary btn-lg" href="newPost.jsp" role="button">새 글 작성</a>
    </div>

    <!-- 게시판 테이블 -->
    <div class="container mt-4">
        <h2>게시판</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">제목</th>
                    <th scope="col">기숙사</th>
                    <th scope="col">작성일</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        // 데이터베이스 연결
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sumate?useUnicode=true&characterEncoding=UTF-8", "root", "1234");
                        stmt = conn.createStatement();

                        // 게시물 조회
                        String sql = "SELECT id, title, dormitory, created_at FROM posts ORDER BY created_at DESC";
                        rs = stmt.executeQuery(sql);

                        // 결과를 테이블에 표시
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String title = rs.getString("title");
                            String dormitory = rs.getString("dormitory");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                %>
                            <tr>
                                <th scope="row"><%= id %></th>
                                <td><a href="viewPost.jsp?id=<%= id %>"><%= title %></a></td>
                                <td><%= dormitory %></td>
                                <td><%= createdAt.toString() %></td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        // 리소스 정리
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
    </div>

    <%@ include file="footer.jsp" %> <!-- 풋터 부분 -->
</div>
</body>
</html>
