<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logout page</title>
</head>
<body>
<%
request.getSession().invalidate();
response.sendRedirect("index.jsp");
%>
%</body>
%</html>
