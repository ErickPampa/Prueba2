<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="assets/css/employee-styles.css">
</head>
<body>
    <h1>Bienvenido, Administrador <%= session.getAttribute("user") %>!</h1>
    <nav>
        <ul>
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="inventory.jsp">Gestión Inventario</a></li>
            <li><a href="addProduct.jsp">Agregar Producto</a></li>
            <li><a href="orders.jsp">Órdenes de Compra</a></li>
            <li><a href="providers.jsp">Proveedores</a></li>
            <li><a href="addProvider.jsp">Agregar Proveedor</a></li>
            <li><a href="registerEmployee.jsp">Registrar Empleado</a></li>
            <li><a href="logout.jsp">Cerrar Sesión</a></li>
        </ul>
    </nav>
</body>
</html>
