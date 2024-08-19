<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/main_styles.css">
</head>
<body>
<div class="main-container">
<%@ include file="header.jsp" %>

  <div class="signup-section">
            <div class="divider"></div>
            <div class="signup-text">
                <h2>로그인</h2>
                <p>SU-mate에 가입하여 다양한 서비스를 이용해 보세요.</p>
                <form action="login_user.jsp" method="post" class="signup-form">
                    <div class="form-group">
                        <label for="username"><i class="icon icon-user"></i>아이디</label>
                        <input type="text" id="id" name="id" required>
                    </div>

                    <div class="form-group">
                        <label for="password"><i class="icon icon-lock"></i>비밀번호</label>
                        <input type="password" id="ps" name="ps" required>
                    </div>

                    <button type="submit" class="signup-button" onclick="login()">로그인</button>
                </form>

                <div>
                    <a href="signUp.jsp" class="">아직 SU-mate 회원이 아니신가요?(회원가입)</a>
                </div>
            </div>
            <div class="divider"></div>
    </div>
<%@ include file="footer.jsp" %>
</div>

<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/core.js"></script>
<script>
function login() {
	var id = $("#id").val().trim();
	if (id == "") {
	    alert("아이디를 입력해 주세요.");
		$("#id").focus();
		return;
	}
	
	var ps = $("#ps").val().trim();
	if (ps =="") {
		alert("패스워드를 입력해 주세요.");
		$("#ps").focus();
		return;
	}
	
	var url ="login_user.jsp?id=" + id + "&ps=" + ps;
	AJAX.call(url, null, function(data) {
		var code = data.trim();
		if(code == "NE") {
     	   alert("아이디가 존재하지 않습니다.");
		}
		else if(code == "PE") {
			alert("패스워드가 일치하지 않습니다.");
		}
		else {
			window.location.href = "mainPage.jsp";
		}
		});
	}
	</script>
	<script>
        // JavaScript 코드: 'SU-mate' 제목 클릭 시 index.jsp로 이동
        document.getElementById('title').addEventListener('click', () => {
            window.location.href = 'index.html';
        });
    </script>
</body>
</html>