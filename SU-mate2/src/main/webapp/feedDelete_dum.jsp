<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.FeedDAO_dumale" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.naming.NamingException" %>

<%
    String feedNoStr = request.getParameter("no");
    int feedNo = (feedNoStr != null && !feedNoStr.isEmpty()) ? Integer.parseInt(feedNoStr) : 0;
    String userID = (String) session.getAttribute("id");

    try {
        
        boolean isDeleted = new FeedDAO_dumale().deleteFeed(feedNo, userID);

        out.print(isDeleted ? "success" : "fail");
    } catch (NamingException | SQLException e) {
        e.printStackTrace();
        out.print("error");
    }
%>