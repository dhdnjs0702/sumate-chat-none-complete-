<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
    <link rel="stylesheet" href="/SU_FM/css/main_styles.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="main-container">
    <%@ include file="header_login.jsp" %> <!-- 헤더 부분 -->

    <div class="container mt-4">
        <h2>게시글 상세</h2>

        <%
            // 게시글 ID를 가져오기
            String id = request.getParameter("id");
            String sessionUserID = (String) session.getAttribute("id");  // 현재 로그인한 사용자의 ID 가져오기
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String title = "";
            String description = "";
            String postUserID = "";  // 게시글 작성자의 userID
            Timestamp createdAt = null;

            // 체크리스트 항목들
            String dormitory = "";
            String bedTime = "";
            String wakeTime = "";
            String showerTime = "";
            String showerPeriod = "";
            String sleepHabit = "";
            String cleaning = "";
            String snack = "";
            String alarmSound = "";
            String studyStyle = "";
            String studyTime = "";

            try {
                // 데이터베이스 연결
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sumate?useUnicode=true&characterEncoding=UTF-8", "root", "1234");

                // 게시글 및 체크리스트 항목 조회 쿼리 실행
                String sql = "SELECT * FROM posts WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(id));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    title = rs.getString("title");
                    description = rs.getString("description");
                    postUserID = rs.getString("userID");  // 게시글 작성자의 userID
                    createdAt = rs.getTimestamp("created_at");

                    // 체크리스트 항목 가져오기
                    dormitory = rs.getString("dormitory");
                    bedTime = rs.getString("bedTime");
                    wakeTime = rs.getString("wakeTime");
                    showerTime = rs.getString("showerTime");
                    showerPeriod = rs.getString("showerPeriod");
                    sleepHabit = rs.getString("sleepHabit");
                    cleaning = rs.getString("cleaning");
                    snack = rs.getString("snack");
                    alarmSound = rs.getString("alarmSound");
                    studyStyle = rs.getString("studyStyle");
                    studyTime = rs.getString("studyTime");

                    // 게시글 작성자 ID와 제목에 대한 디버깅 출력
                    System.out.println("게시글 작성자 ID: " + postUserID);
                    System.out.println("게시글 제목: " + title);
                } else {
                    // 게시글이 없을 때 경고 메시지
                    System.out.println("게시글을 찾을 수 없습니다.");
                    %>
                    <div class="alert alert-warning" role="alert">게시글을 찾을 수 없습니다.</div>
                    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("에러 발생: " + e.getMessage());
            } finally {
                // 리소스 정리
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>

        <div class="mb-3">
            <h3><%= title %></h3>
            <p><%= description %></p>
            <small>작성일: <%= createdAt %></small>
        </div>

        <!-- 체크리스트 내용 표시 -->
        <div class="mb-3">
            <h4>체크리스트</h4>
            <p><strong>기숙사:</strong> <%= dormitory %></p>
            <p><strong>취침시간:</strong> <%= bedTime %></p>
            <p><strong>기상시간:</strong> <%= wakeTime %></p>
            <p><strong>샤워 소요 시간:</strong> <%= showerTime %></p>
            <p><strong>샤워 시간:</strong> <%= showerPeriod %></p>
            <p><strong>잠버릇:</strong> <%= sleepHabit %></p>
            <p><strong>청소 빈도:</strong> <%= cleaning %></p>
            <p><strong>야식:</strong> <%= snack %></p>
            <p><strong>알람 소리:</strong> <%= alarmSound %></p>
            <p><strong>공부하는 스타일:</strong> <%= studyStyle %></p>
            <p><strong>공부 시간:</strong> <%= studyTime %></p>
        </div>

        <!-- 대화하러 가기 버튼 -->
        <button class="btn btn-secondary" onclick="redirectToChat('<%= postUserID %>')">대화하러 가기</button>

        <a class="btn btn-secondary" href="roomMate.jsp" role="button">목록으로 돌아가기</a>

        <!-- 게시글 삭제 버튼 (작성자만 보이게) -->
        <%
        String userID = (String) request.getSession().getAttribute("id");

        // 디버깅: 로그인한 사용자의 ID와 게시글 작성자의 ID 확인
        System.out.println("로그인한 사용자 ID: " + userID);
        System.out.println("게시글 작성자 ID: " + postUserID);

        // 현재 로그인한 사용자가 글 작성자일 경우 삭제 버튼 보여주기
        if (userID != null && userID.equals(postUserID)) { 
        %>
            <form action="deletePost.jsp" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="postID" value="<%= id %>">
                <button type="submit" class="btn btn-danger mt-3">삭제하기</button>
            </form>
        <% 
        } 
        %>
    </div>

    <%@ include file="footer.jsp" %> <!-- 풋터 부분 -->
</div>

<script>
    // 채팅으로 이동하는 자바스크립트 함수
    function redirectToChat(toID) {
        var userID = '<%= sessionUserID %>'; // 현재 로그인한 사용자 ID

        if (toID && toID.trim() !== "") {
            if (userID === toID) {
                alert("자기 자신과는 채팅할 수 없습니다.");
            } else {
                var confirmMessage = "해당 사용자와 채팅하시겠습니까?";
                if (confirm(confirmMessage)) { 
                    window.location.href = "chat.jsp?toID=" + encodeURIComponent(toID);
                }
            }
        } else {
            alert("잘못된 유저 정보입니다.");
        }
    }
</script>

</body>
</html>
