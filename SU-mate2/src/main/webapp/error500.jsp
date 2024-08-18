<%@ page isErrorPage="true" %>
<html>
<head><title>Error</title></head>
<body>
<h2>Error Details</h2>
<p>Status Code: <%= response.getStatus() %></p>
<p>Exception: <%= exception.getMessage() %></p>
<p>Stack Trace:</p>
<pre>
<% exception.printStackTrace(new java.io.PrintWriter(out)); %>
</pre>
</body>
</html>