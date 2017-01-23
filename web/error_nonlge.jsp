<%--
  Created by IntelliJ IDEA.
  User: sunjoo
  Date: 23/01/2017
  Time: 10:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%= request.getParameter("message") %>
<%
  request.getSession().invalidate();
%>
</body>
</html>
