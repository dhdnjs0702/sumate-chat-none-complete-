<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="chat.ChatDAO" %>
<%@ page import="java.util.Map" %>

<%
    String userID = request.getParameter("userID");
    ChatDAO chatDAO = new ChatDAO();
    Map<String, Integer> unreadCounts = chatDAO.getUnreadMessageCountByChat(userID);
    
    response.setContentType("application/json");
    StringBuilder jsonBuilder = new StringBuilder();
    jsonBuilder.append("{");
    boolean first = true;
    for (Map.Entry<String, Integer> entry : unreadCounts.entrySet()) {
        if (!first) {
            jsonBuilder.append(",");
        }
        jsonBuilder.append("\"").append(entry.getKey()).append("\":");
        jsonBuilder.append(entry.getValue());
        first = false;
    }
    jsonBuilder.append("}");
    
    out.print(jsonBuilder.toString());
%>