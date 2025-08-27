<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<%
    String productId = request.getParameter("id");
    if (productId == null || productId.isEmpty()) {
        response.sendRedirect("inventario.jsp"); // Redirigir si no se proporciona un ID válido
        return;
    }

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
    <title>Editar Producto</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>Editar Producto</h1>
    <nav>
        <ul>
            <li><a href="inventory.jsp">Gestión de Inventario</a></li>
            <li><a href="orders.jsp">Órdenes de Compra</a></li>
            <li><a href="providers.jsp">Proveedores</a></li>
            <li><a href="addProvider.jsp">Agregar Proveedor</a></li>
            <% if ("admin".equals(currentSession.getAttribute("role"))) { %>
                <li><a href="registerEmployee.jsp">Registrar Empleado</a></li>
            <% } %>
            <li><a href="logout.jsp">Cerrar Sesión</a></li>
        </ul>
    </nav>

    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DatabaseConnection.initializeDatabase();
            String query = "SELECT * FROM products WHERE id=?";
            ps = con.prepareStatement(query);
            ps.setString(1, productId);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Obtener datos del producto para prellenar el formulario de edición
                String name = rs.getString("name");
                String description = rs.getString("description");
                int stock = rs.getInt("stock");
                double price = rs.getDouble("price");

    %>
    <form action="updateProduct.jsp" method="post">
        <input type="hidden" name="id" value="<%= productId %>">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" value="<%= name %>" required><br><br>

        <label for="description">Descripción:</label><br>
        <textarea id="description" name="description" rows="4" cols="50"><%= description %></textarea><br><br>

        <label for="stock">Stock:</label>
        <input type="number" id="stock" name="stock" value="<%= stock %>" required><br><br>

        <label for="price">Precio Unitario:</label>
        <input type="number" id="price" name="price" step="0.01" value="<%= price %>" required><br><br>

        <input type="submit" value="Actualizar Producto">
    </form>
    <%
            } else {
                out.println("<p>Producto no encontrado.</p>");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
