<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.simple.JSONObject, org.json.simple.parser.JSONParser"%>
<%@ page import="dao.UserDAO" %>
<%
    String toID = request.getParameter("toID");
    String nickname = null;

    try {
        UserDAO userDAO = new UserDAO();  // 객체 직접 생성
        nickname = userDAO.getNickname(toID);  // toID의 닉네임 가져오기
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 닉네임을 JSON 형태로 반환
    JSONObject jsonResponse = new JSONObject();
    jsonResponse.put("nickname", nickname);
    out.print(jsonResponse.toJSONString());
%>