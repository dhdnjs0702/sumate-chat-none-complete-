<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
</head>
<body>
        <div class="header">
            <div class="logo"></div>
            <div class="title" id="title">SU-mate</div>
       		
            <div class="menu">
                <a href="roomMate.jsp" class="menu-item">기숙사 룸메이트</a>
                <a href="dusata_m.jsp" class="menu-item">두유는 사랑을 타고</a>
                <a href="mealCompanion.jsp" class="menu-item">밥친구</a>
                <a href="carPool.jsp" class="menu-item">카풀</a>
                <div class="search-bar">
                    <form action="login.jsp" class="search-form">
                        <button type="submit" class="search-button">로그인 / 회원가입</button>
                    </form>
                </div>
            </div>
        </div>
        
        
    <script>
        // JavaScript 코드: 'SU-mate' 제목 클릭 시 index.jsp로 이동
        document.getElementById('title').addEventListener('click', () => {
            window.location.href = '../index.html';
        });
    </script>
</body>
</body>
</html>