<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="org.json.simple.parser.ParseException" %>


<%
    // 세션에서 사용자 ID 가져오기
    String uid = (String) session.getAttribute("id");
    
    if (uid == null || uid.isEmpty()) {
        out.print("Guest"); // 로그인하지 않은 경우
    } else {
        UserDAO userDAO = new UserDAO();
        try {
            String nickname = userDAO.getNickname(uid);
            if (nickname != null && !nickname.isEmpty()) {
                out.print(nickname);
            } else {
                out.print(uid); // 닉네임이 없는 경우 ID를 출력
            }
        } catch (Exception e) {
            out.print("Unknown"); // 에러 발생 시
            e.printStackTrace();
        }
    }
%>