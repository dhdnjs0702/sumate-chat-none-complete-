<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<% //디버깅
System.out.println("All parameters:");
java.util.Enumeration<String> parameterNames = request.getParameterNames();
while (parameterNames.hasMoreElements()) {
    String paramName = parameterNames.nextElement();
    String[] paramValues = request.getParameterValues(paramName);
    for (String paramValue : paramValues) {
        System.out.println(paramName + " = " + paramValue);
    }
}
%>
<%
 request.setCharacterEncoding("utf-8");

String uid = request.getParameter("id");
String jsonstr = request.getParameter("jsonstr");

//디버깅을 위한 출력
System.out.println("Received ID: " + uid);
System.out.println("Received JSON: " + jsonstr);

UserDAO dao = new UserDAO();
if (dao.exists(uid)) {
	out.print("EX");
	return;
}
if (dao.insert(uid, jsonstr)) {
	session.setAttribute("id", uid);
	out.print("OK");
}
else {
	out.print("ER");
}
%>