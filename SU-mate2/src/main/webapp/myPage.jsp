<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%
    // 로그인 상태 확인
    String uid = (String) session.getAttribute("id");
	String upass = (String) session.getAttribute("ps");
    if (uid == null) {
%>
        <script type="text/javascript">
            alert("로그인 후 이용가능한 컨텐츠입니다.");
            window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        </script>
<%
        return; // JSP 페이지 실행 종료
    }

    // 로그인 상태인 경우 세션에 사용자 ID와 비밀번호를 다시 설정 (필요에 따라)
    session.setAttribute("id", uid);
    session.setAttribute("upass", upass);
%>
</head>
<body>
	<form id="withdrawForm" action="withDraw.jsp" method="post" onsubmit="return validateForm()">
		<table align=center>
			<tr><td colspan=2 align=center height=40><b>회원탈퇴</b><td></tr>
			<tr>
				<td align=right>아이디&nbsp;</td>
				<td><input type="text" name="id" placeholder="아이디를 입력해주세요." required></td>
			</tr>
			<tr>
				<td align=right>비밀번호&nbsp;</td>
				<td><input type="password" id="ps" name="ps" placeholder="비밀번호를 입력해주세요." required></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<a class="warning-message" style="color: red;"></a>
				</td>
			</tr>
			<tr>
				<td colspan=2 align=center height=50>
					<input type="submit" value="회원탈퇴하기">
				</td>
			</tr>
		</table>
	</form>

	<script type="text/javascript">
		function validateForm() {
			// 서버에서 세션에 저장된 비밀번호 가져오기
			var serverID = "<%= uid%>";
			var serverPassword = "<%= upass %>";
			
			// 사용자가 입력한 비밀번호 가져오기
			var userPassword = document.getElementById("ps").value;
			var userID = document.getElementByID("id").value;
			// 비밀번호 일치 여부 확인
			if (userPassword !== serverPassword) {
				// 경고 메시지를 <a> 요소에 출력
				document.querySelector(".warning-message").innerText = "비밀번호를 잘못 입력하셨습니다.";
				return false; // 폼 제출 막기
			}else if (userID !== serverID){
				document.querySelector(".warning-message").innerText = "아이디를 잘못 입력하셨습니다.";
				return false; // 폼 제출 막기
			}
			
			return true; // 비밀번호가 일치하면 폼을 제출
		}
	</script>
</body>
</html>