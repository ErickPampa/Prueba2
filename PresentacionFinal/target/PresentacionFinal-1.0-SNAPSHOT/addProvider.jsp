<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Obtener la sesión sin crear una nueva si no existe
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agregar Proveedor</title>
    <link rel="stylesheet" type="text/css" href="assets/css/addprovider-styles.css">
</head>
<body>
    
    <h1>Agregar Proveedor</h1>
    <nav>
        <ul>
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="inventory.jsp">Gestión de Inventario</a></li>
            <li><a href="addProduct.jsp">Agregar Producto</a></li>
            <li><a href="orders.jsp">Órdenes de Compra</a></li>
            <li><a href="providers.jsp">Proveedores</a></li>
            <li><a href="addProvider.jsp">Agregar Proveedor</a></li>
            <% if ("admin".equals(currentSession.getAttribute("role"))) { %>
                <li><a href="registerEmployee.jsp">Registrar Empleado</a></li>
            <% } %>
            <li><a href="logout.jsp">Cerrar Sesión</a></li>
        </ul>
    </nav>
    <form action="addProvider" method="post">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Correo:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="phone">Teléfono:</label>
        <input type="text" id="phone" name="phone" required><br><br>

        <label for="address">Dirección:</label>
        <input type="text" id="address" name="address" required><br><br>

        <input type="submit" value="Agregar Proveedor">
    </form>
    
</body>
</html>
