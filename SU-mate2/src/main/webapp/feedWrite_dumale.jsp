<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포스트잇 작성하기</title>
<link rel="stylesheet" href="css/du_feed.css">
</head>
<body>

<%
    String userID=null;
    if(session.getAttribute("id") !=null){
        userID = (String) session.getAttribute("id");
    }
%>
<%
    // 로그인 상태 확인
    if (userID == null) {
%>
        <script type="text/javascript">
            alert("로그인 후 이용가능한 컨텐츠입니다.");
            window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        </script>
<%
        return; // JSP 페이지 실행 종료
    }

    // 로그인 상태인 경우 세션에 사용자 ID를 다시 설정 (필요에 따라)
    session.setAttribute("id", userID);
   
%>
    <div class="container">
    <a href="javascript:history.back()" class="back-arrow">←</a>
        <h1>포스트잇 작성하기</h1>
        <form id="feedForm" action="feedAdd_dumale.jsp" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="nickname">닉네임:</label>
                <span id="userNickname">Unknown</span>
            </div>
            <div class="form-group">
                <label for="content">작성글:</label>
                <textarea id="content" name="content" maxlength="100" required></textarea>
                <div id="charCount">0 / 100</div> <!-- 글자 수 표시 -->
            </div>
            <div class="form-group">
                <label for="image">이미지:</label>
                <input type="file" id="image" name="image" disabled>
            </div>
            <button type="submit">글 작성</button>
        </form>
    </div>
</body>
<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/core.js"></script>
<script>
$(document).ready(function() {
    // 사용자 닉네임 가져오기
    $.ajax({
        url: 'getUserNickname.jsp',  // 서버에서 닉네임을 가져오는 JSP 파일
        method: 'GET',
        success: function(response) {
            $('#userNickname').text(response);
        },
        error: function() {
            $('#userNickname').text('Unknown');
        }
    });

    // 글자 수 제한
    $('#content').on('input', function() {
        var charCount = $(this).val().length;
        $('#charCount').text(charCount + " / 100");
    });


    $('#feedForm').submit(function(e) {
        e.preventDefault();
        
        var formData = new FormData(this);
        var content = $('#content').val();
        
        var jsonData = {
            content: content,
            ts: new Date().getTime()
        };
       	
        formData.append("jsonstr", JSON.stringify(jsonData));
        
        $.ajax({
            url: 'feedAdd_dumale.jsp',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                if(response.trim() === "OK") {
                    alert("글이 성공적으로 작성되었습니다.");
                    window.location.href = 'dusata_m.jsp';  // 글 목록 페이지로 리다이렉트
                } else {
                    alert("글 작성에 실패했습니다. 다시 시도해주세요.");
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다. 나중에 다시 시도해주세요.");
            }
        });
    });
});
</script>
</html>