<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>

<%
    // 디버깅
    System.out.println("All parameters:");
    java.util.Enumeration<String> parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        String[] paramValues = request.getParameterValues(paramName);
        for (String paramValue : paramValues) {
            System.out.println(paramName + " = " + paramValue);
        }
    }

    request.setCharacterEncoding("utf-8");

    String uid = request.getParameter("id");
    String jsonstr = request.getParameter("jsonstr");

    // 디버깅을 위한 출력
    System.out.println("Received ID: " + uid);
    System.out.println("Received JSON: " + jsonstr);

    // JSON 파싱
    JSONParser parser = new JSONParser();
    String nickname = null;
    try {
        JSONObject json = (JSONObject) parser.parse(jsonstr);
        nickname = (String) json.get("nickname"); // JSON에서 닉네임 추출
    } catch (ParseException e) {
        e.printStackTrace();
        out.print("ER"); // JSON 파싱 오류 시 ER 리턴
        return;
    }

    // DAO 객체 생성
    UserDAO dao = new UserDAO();

    // ID 중복 확인
    if (dao.exists(uid)) {
        out.print("EX");
        return;
    }

    // 닉네임 중복 확인
    if (dao.nicknameExists(nickname)) {
        out.print("NEX"); // 닉네임 중복 시 NEX 리턴
        return;
    }

    // 회원가입 처리
    if (dao.insert(uid, jsonstr)) {
        session.setAttribute("id", uid);
        out.print("OK");
    } else {
        out.print("ER");
    }
%>