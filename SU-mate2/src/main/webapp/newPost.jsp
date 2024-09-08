<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기숙사 룸메이트 체크리스트</title>
    <link rel="stylesheet" href="/SU_FM/css/main_styles.css">
    <link rel="stylesheet" href="/SU_FM/css/NewRoomMate_styles.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="main-container">
<%@ include file="header_login.jsp" %> <!-- 헤더 부분 -->

<div class="container mt-5">
    <h2 class="text-center mb-4">기숙사 룸메이트 체크리스트</h2>

    <!-- 폼 제출 처리 -->
    <%
        String userID = (String) session.getAttribute("id");  // 현재 로그인한 사용자의 ID
        String title = request.getParameter("title");
        String dormitory = request.getParameter("dormitory");
        String bedTime = request.getParameter("bedTime");
        String wakeTime = request.getParameter("wakeTime");
        String showerTime = request.getParameter("showerTime");
        String showerPeriod = request.getParameter("showerPeriod");
        String sleepHabit = request.getParameter("sleepHabit");
        String cleaning = request.getParameter("cleaning");
        String snack = request.getParameter("snack");
        String alarmSound = request.getParameter("alarmSound");
        String studyStyle = request.getParameter("studyStyle");
        String studyTime = request.getParameter("studyTime");
        String description = request.getParameter("description");

        if (userID != null && title != null && dormitory != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // 데이터베이스 연결 설정
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sumate?useUnicode=true&characterEncoding=UTF-8", "root", "1234");


                // SQL 쿼리 준비
                String sql = "INSERT INTO posts (title, dormitory, bedTime, wakeTime, showerTime, showerPeriod, sleepHabit, cleaning, snack, alarmSound, studyStyle, studyTime, description, userID, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, title);
                pstmt.setString(2, dormitory);
                pstmt.setString(3, bedTime);
                pstmt.setString(4, wakeTime);
                pstmt.setString(5, showerTime);
                pstmt.setString(6, showerPeriod);
                pstmt.setString(7, sleepHabit);
                pstmt.setString(8, cleaning);
                pstmt.setString(9, snack);
                pstmt.setString(10, alarmSound);
                pstmt.setString(11, studyStyle);
                pstmt.setString(12, studyTime);
                pstmt.setString(13, description);
                pstmt.setString(14, userID);  // 작성자 ID 저장

                int result = pstmt.executeUpdate();

                if(result > 0) {
                    // 성공적으로 저장되면 roomMate.jsp로 리다이렉트
                    response.sendRedirect("roomMate.jsp");
                    return; // 리다이렉트 후 더 이상의 코드를 실행하지 않음
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>데이터 저장에 실패했습니다. 다시 시도해주세요.</div>");
                }

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>오류가 발생했습니다: " + e.getMessage() + "</div>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>
</div>

    <!-- 입력 폼 -->
    <form method="POST" action="newPost.jsp" accept-charset="UTF-8">
        <!-- 제목 입력 -->
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력하세요" required>
        </div>

        <!-- 기숙사 선택 -->
        <div class="mb-3">
            <label for="dormitory" class="form-label">기숙사</label>
            <select name="dormitory" class="form-select" required>
                <option value="peniel-2female">브니엘관(여) 2인실</option>
                <option value="salem-2male">살렘관(남) 2인실</option>
                <option value="zion-2male">시온관(남) 2인실</option>
                <option value="eden-3female">에덴관(여) 3인실</option>
                <option value="zion-3male">시온 3인실</option>
                <option value="zion-4male">시온 4인실</option>
                <option value="eden-4female">에덴 4인실</option>
            </select>
        </div>

        <!-- 취침시간 -->
        <div class="mb-3">
            <label for="bedTime" class="form-label">취침시간</label>
            <select name="bedTime" class="form-select">
                <option value="9시">9시</option>
                <option value="10시">10시</option>
                <option value="11시">11시</option>
                <option value="12시">12시</option>
                <option value="1시">1시</option>
                <option value="2시">2시</option>
                <option value="3시 이후">3시 이후</option>
            </select>
        </div>

        <!-- 기상시간 -->
        <div class="mb-3">
            <label for="wakeTime" class="form-label">기상시간</label>
            <select name="wakeTime" class="form-select">
                <option value="4시">4시</option>
                <option value="5시">5시</option>
                <option value="6시">6시</option>
                <option value="7시">7시</option>
                <option value="8시">8시</option>
                <option value="9시 이후">9시 이후</option>
                <option value="없음">기상 시간 없음</option>
            </select>
        </div>

        <!-- 샤워 소요 시간 -->
        <div class="mb-3">
            <label for="showerTime" class="form-label">샤워 소요 시간</label>
            <select name="showerTime" class="form-select">
                <option value="5분">5분</option>
                <option value="10분">10분</option>
                <option value="15분">15분</option>
                <option value="20분">20분</option>
                <option value="25분">25분</option>
                <option value="30분 이상">30분 이상</option>
            </select>
        </div>

        <!-- 샤워 시간 -->
        <div class="mb-3">
            <label for="showerPeriod" class="form-label">샤워 시간</label>
            <select name="showerPeriod" class="form-select">
                <option value="아침 샤워">아침 샤워</option>
                <option value="저녁 샤워">저녁 샤워</option>
                <option value="유동적">유동적</option>
            </select>
        </div>

        <!-- 잠버릇 -->
        <div class="mb-3">
            <label for="sleepHabit" class="form-label">잠버릇</label>
            <select name="sleepHabit" class="form-select">
                <option value="코골이">코골이</option>
                <option value="이갈이">이갈이</option>
                <option value="잘 뒤척임">잘 뒤척임</option>
                <option value="없음">없음</option>
            </select>
        </div>

        <!-- 청소 -->
        <div class="mb-3">
            <label for="cleaning" class="form-label">청소 빈도</label>
            <select name="cleaning" class="form-select">
                <option value="규칙적으로">규칙적으로</option>
                <option value="필요할 때">필요할 때</option>
                <option value="거의 안함">거의 안함</option>
            </select>
        </div>

        <!-- 야식 -->
        <div class="mb-3">
            <label for="snack" class="form-label">야식</label>
            <select name="snack" class="form-select">
                <option value="허용">허용</option>
                <option value="불허용">불허용</option>
            </select>
        </div>

        <!-- 알람 소리 -->
        <div class="mb-3">
            <label for="alarmSound" class="form-label">알람 소리</label>
            <select name="alarmSound" class="form-select">
                <option value="작게">작게</option>
                <option value="보통">보통</option>
                <option value="크게">크게</option>
            </select>
        </div>

        <!-- 공부하는 스타일 -->
        <div class="mb-3">
            <label for="studyStyle" class="form-label">공부하는 스타일</label>
            <select name="studyStyle" class="form-select">
                <option value="조용히">조용히</option>
                <option value="음악을 들으며">음악을 들으며</option>
                <option value="토론하며">토론하며</option>
                <option value="움직이면서">움직이면서</option>
            </select>
        </div>

        <!-- 공부 시간 -->
        <div class="mb-3">
            <label for="studyTime" class="form-label">공부 시간</label>
            <select name="studyTime" class="form-select">
                <option value="아침">아침</option>
                <option value="오후">오후</option>
                <option value="밤">밤</option>
                <option value="유동적">유동적</option>
            </select>
        </div>

        <!-- 내용 -->
        <div class="mb-3 mt-4">
            <label for="description" class="form-label">내용</label>
            <textarea class="form-control" id="description" name="description" rows="3" placeholder="내용을 입력하세요"></textarea>
        </div>

        <!-- 제출 버튼 -->
        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary">제출하기</button>
        </div>
    </form>
</div>

<%@ include file="footer.jsp" %> <!-- 풋터 부분 -->


</body>
</html>
