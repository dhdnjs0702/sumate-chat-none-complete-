<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.FeedDAO_dumale" %>
<%@ page import="java.util.*" %>

<%
    String maxNoStr = request.getParameter("maxNo");
    int maxNo = (maxNoStr != null && !maxNoStr.isEmpty()) ? Integer.parseInt(maxNoStr) : 0;
    out.print((new FeedDAO_dumale()).getGroup(maxNo));
%>