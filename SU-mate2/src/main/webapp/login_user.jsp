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
        out.print("<script>alert('ER: " + e.getMessage() + "'); history.back();</script>");
        return;
    }

    if (code == 1) {
        out.print("<script>alert('아이디가 존재하지 않습니다.'); history.back();</script>");
    } else if (code == 2) {
        out.print("<script>alert('패스워드가 일치하지 않습니다.'); history.back();</script>");
    } else if (code == 0) {
        session.setAttribute("id", uid);

        // 닉네임을 가져와서 세션에 저장
        try {
            String nickname = dao.getNickname(uid);
            session.setAttribute("nickname", nickname);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        out.print("<script>alert('성공적으로 로그인되었습니다.'); location.href='mainPage.jsp';</script>");
    } else {
        out.print("<script>alert('로그인에 실패했습니다.'); history.back();</script>");
    }
%>