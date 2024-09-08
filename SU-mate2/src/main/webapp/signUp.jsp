<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<link rel="stylesheet" href="css/main_styles.css">
</head>
<body>
 <div class="main-container">
<%@ include file="header.jsp" %>

  <div class="signup-section">
            <div class="divider"></div>
            <div class="signup-text">
                <h2>회원 가입</h2>
                <p>SU-mate에 가입하여 다양한 서비스를 이용해 보세요.</p>
                <form action="register.jsp" method="post" class="signup-form">
                    <div class="form-group">
                        <label for="id"><i class="icon icon-user"></i>아이디</label>
                        <input type="text" id="id" name="id" required>
                    </div>

                    <div class="form-group">
                        <label for="ps"><i class="icon icon-lock"></i>비밀번호</label>
                        <input type="password" id="ps" name="ps" required>
                    </div>

                    <div class="form-group">
                        <label for="pscheck"><i class="icon icon-lock"></i>비밀번호 확인</label>
                        <input type="password" id="pscheck" name="pscheck" required>
                    </div>

                    <div class="form-group">
                        <label for="nickname"><i class="icon icon-user"></i>닉네임</label>
                        <input type="text" id="nickname" name="nickname" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="gender"><i class="icon icon-gender"></i>성별</label>
                        <div class="gender-options">
                            <input type="radio" id="male" name="gender" value="male" required>
                            <label for="male">남자</label>
                            <input type="radio" id="female" name="gender" value="female" required>
                            <label for="female">여자</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="mbti"><i class="icon icon-personality"></i>MBTI</label>
                        <select id="mbti" name="mbti" required>
                            <option value="">선택하세요</option>
                            <option value="ISTJ">ISTJ</option>
                            <option value="ISFJ">ISFJ</option>
                            <option value="INFJ">INFJ</option>
                            <option value="INTJ">INTJ</option>
                            <option value="ISTP">ISTP</option>
                            <option value="ISFP">ISFP</option>
                            <option value="INFP">INFP</option>
                            <option value="INTP">INTP</option>
                            <option value="ESTP">ESTP</option>
                            <option value="ESFP">ESFP</option>
                            <option value="ENFP">ENFP</option>
                            <option value="ENTP">ENTP</option>
                            <option value="ESTJ">ESTJ</option>
                            <option value="ESFJ">ESFJ</option>
                            <option value="ENFJ">ENFJ</option>
                            <option value="ENTJ">ENTJ</option>
                        </select>
                    </div>

                   <div class="form-group">
				    <label for="smoking"><i class="icon icon-smoking"></i>흡연 여부</label>
				    <div class="options-row">
				        <input type="radio" id="smoking_yes" name="smoking" value="yes" required>
				        <label for="smoking_yes">예</label>
				        <input type="radio" id="smoking_no" name="smoking" value="no" required>
				        <label for="smoking_no">아니오</label>
				    </div>
					</div>
				
					<div class="form-group">
				    <label for="workout"><i class="icon icon-workout"></i>운동 여부</label>
				    <div class="options-row">
				        <input type="radio" id="workout_yes" name="workout" value="yes" required>
				        <label for="workout_yes">예</label>
				        <input type="radio" id="workout_no" name="workout" value="no" required>
				        <label for="workout_no">아니오</label>
				    </div>
					</div>
                    
                    <button type="submit" class="signup-button">회원 가입</button>
                </form>
            </div>
            <div class="divider"></div>
        </div>

<%@ include file="footer.jsp" %>
</div>
<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/core.js"></script>
<script>
$(document).ready(function() {
    $(".signup-form").on("submit", function(e) {
        e.preventDefault();
        signup();
    });
});

function signup() {
    var id = $("#id").val().trim();
    var ps = $("#ps").val().trim();
    var pscheck = $("#pscheck").val().trim();
    var nickname = $("#nickname").val().trim();
    var gender = $("input[name='gender']:checked").val();
    var mbti = $("#mbti").val();
    var smoking = $("input[name='smoking']:checked").val();
    var workout = $("input[name='workout']:checked").val();

    // 입력 검증
    if (id == "") {
        alert("아이디를 입력해 주세요.");
        $("#id").focus();
        return;
    }
    if (ps == "") {
        alert("비밀번호를 입력해 주세요.");
        $("#ps").focus();
        return;
    }
    if (ps !== pscheck) {
        alert("비밀번호가 일치하지 않습니다.");
        $("#pscheck").focus();
        return;
    }
    if (nickname == "") {
        alert("닉네임을 입력해 주세요.");
        $("#nickname").focus();
        return;
    }
    if (!gender) {
        alert("성별을 선택해 주세요.");
        return;
    }
    if (mbti == "") {
        alert("MBTI를 선택해 주세요.");
        $("#mbti").focus();
        return;
    }
    if (!smoking) {
        alert("흡연 여부를 선택해 주세요.");
        return;
    }
    if (!workout) {
        alert("운동 여부를 선택해 주세요.");
        return;
    }

    var usrobj = {
        id: id,
        password: ps,
        nickname: nickname,
        gender: gender,
        mbti: mbti,
        smoking: smoking,
        workout: workout
    };
    var jsonstr = JSON.stringify(usrobj);

    console.log("Sending data:", {id: id, jsonstr: jsonstr});

    $.ajax({
        type: "POST",
        url: "register.jsp",
        data: {id: id, jsonstr: jsonstr},
        dataType: "text",
        success: function(response) {
            console.log("Server response:", response);
            var code = response.trim();
            if(code == "EX") {
                alert("이미 가입한 회원입니다.");
            } else if (code == "NEX"){
            	alert("닉네임이 중복됩니다.");
            } else if(code == "ER") {
                alert("회원가입 처리 중 에러가 발생하였습니다.");
            } else if(code == "OK") {
                alert("회원 가입이 완료되었습니다.");
                window.location.href = "login.jsp";
            } else {
                alert("알 수 없는 응답: " + code);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error("AJAX error:", textStatus, errorThrown);
            alert("회원가입 처리 중 오류가 발생했습니다.");
        }
    });
}

function getToday() {
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);
    return year + "-" + month + "-" + day;
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