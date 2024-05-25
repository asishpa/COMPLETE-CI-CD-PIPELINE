<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Demo Web App</title>
</head>
<body>
    <h1>Welcome to My Demo Web App</h1>
    
    <%
        // Importing required classes
        import java.util.Date;
        // Getting the current date and time
        Date currentDate = new Date();
    %>
    
    <p>Current Date and Time: <%= currentDate.toString() %></p>
    
    <h2>Submit Your Information</h2>
    <form action="process.jsp" method="post">
        Name: <input type="text" name="name" required><br>
        Email: <input type="email" name="email" required><br>
        <input type="submit" value="Submit">
    </form>
    
    <h2>Server-Side Scripting Example</h2>
    <%
        String message = "This message is generated from JSP!";
        out.println("<p>" + message + "</p>");
    %>
</body>
</html>
