<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<%
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
    <title>Proveedores</title>
    <link rel="stylesheet" type="text/css" href="assets/css/providers-styles.css">
</head>
<body>
    <h1>Lista de Proveedores</h1>
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

    <form action="providers.jsp" method="get">
        <input type="text" name="search" placeholder="Buscar proveedor...">
        <input type="submit" value="Buscar">
    </form>

    <%
        String search = request.getParameter("search");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DatabaseConnection.initializeDatabase();
            String query = "SELECT * FROM providers";
            if (search != null && !search.isEmpty()) {
                search = "%" + search.toLowerCase() + "%";
                query += " WHERE LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(phone) LIKE ? OR LOWER(address) LIKE ?";
                ps = con.prepareStatement(query);
                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, search);
                ps.setString(4, search);
            } else {
                ps = con.prepareStatement(query);
            }
            rs = ps.executeQuery();

            out.println("<table>");
            out.println("<tr><th>Nombre</th><th>Correo</th><th>Teléfono</th><th>Dirección</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("phone") + "</td>");
                out.println("<td>" + rs.getString("address") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
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
