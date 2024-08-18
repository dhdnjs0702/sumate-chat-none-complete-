<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	out.println(session.getAttribute("id"));
%>

<!-- 로그인 처리를 위한 session객체의 값을 제공합니다  -->