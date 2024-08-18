<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%
session.invalidate(); // 세션 무효화 (로그아웃)
// out.print("로그아웃 하였습니다.");
%>
<script type="text/javascript">
    alert("로그아웃을 완료하였습니다."); // 경고창 표시
    window.location.href = 'login.jsp'; // login.jsp 페이지로 리다이렉트
</script>