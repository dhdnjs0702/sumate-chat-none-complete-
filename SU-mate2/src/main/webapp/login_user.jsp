<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>

<%
    request.setCharacterEncoding("UTF-8");
    String uid = request.getParameter("id");
    String upass = request.getParameter("ps");

    UserDAO dao = new UserDAO();
    int code = -1;
    try {
        code = dao.login(uid, upass);
    } catch (Exception e) {
        e.printStackTrace();
        out.print("ER: " + e.getMessage());
    }

    if (code == 1) {
        out.print("NE"); // 아이디가 존재하지 않습니다.
    } else if (code == 2) {
        out.print("PE"); // 패스워드가 일치하지 않습니다.
    } else if (code == 0) {
        session.setAttribute("id", uid);

        // 닉네임을 가져와서 세션에 저장
        try {
            String nickname = dao.getNickname(uid);
            session.setAttribute("nickname", nickname);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        out.print("OK"); // 로그인 성공
        response.sendRedirect("mainPage.jsp");
    } else {
        out.print("ER: Login failed"); // 기타 오류
    }
%>



