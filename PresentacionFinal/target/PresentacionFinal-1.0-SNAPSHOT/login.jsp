<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="assets/css/login-styles.css">
    
</head>
<body>
    <div class="login-container">
        <h2 style="color: #0056b3;">Login</h2>
        <form action="authenticate" method="post">
            <label>Correo:</label>
            <input type="text" name="email" required><br>
            <label>Contraseña:</label>
            <input type="password" name="password" required><br><br>
            <input type="submit" value="Login">
        </form>
        
        <%-- Manejar errores de autenticación --%>
        <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p class="error-message">Error de autenticación. Verifica tus credenciales.</p>
        <% } %>
    </div>
</body>
</html>
