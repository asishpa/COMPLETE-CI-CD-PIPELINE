<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Form Submission</title>
</head>
<body>
    <h1>Form Submission Result</h1>
    
    <%
        // Retrieving form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        // Simple validation (could be expanded as needed)
        if(name != null && email != null && !name.isEmpty() && !email.isEmpty()) {
    %>
            <p>Thank you, <%= name %>! We have received your email address (<%= email %>).</p>
    <%
        } else {
    %>
            <p>Invalid input. Please go back and try again.</p>
    <%
        }
    %>
    
    <a href="index.jsp">Go Back to Home</a>
</body>
</html>
