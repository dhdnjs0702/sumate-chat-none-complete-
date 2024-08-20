<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="chat.ChatDAO" %>
<%
    String userID = request.getParameter("userID");
    String toID = request.getParameter("toID");

    System.out.println("deleteChat.jsp: userID = " + userID + ", toID = " + toID);

    ChatDAO chatDAO = new ChatDAO();
    boolean isDeleted = chatDAO.deleteChat(userID, toID);
    
    if(isDeleted) {
        System.out.println("Chat successfully deleted.");
        out.print("success");
        out.flush();  // 버퍼에 남아 있는 데이터를 출력
    } else {
        System.out.println("Failed to delete chat.");
        out.print("fail");
        out.flush();  // 버퍼에 남아 있는 데이터를 출력
    }
%>