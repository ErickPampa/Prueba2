<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>

<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("role") == null || !"admin".equals(currentSession.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String status = request.getParameter("status");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Empleado</title>
    <link rel="stylesheet" type="text/css" href="assets/css/register-styles.css">
    <style>
        form input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 14px 40px;
            font-size: 18px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        form input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Registrar Empleado</h1>
    <nav>
        <ul>
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="inventory.jsp">Gestión de Inventario</a></li>
            <li><a href="addProduct.jsp">Agregar Producto</a></li>
            <li><a href="orders.jsp">Órdenes de Compra</a></li>
            <li><a href="providers.jsp">Proveedores</a></li>
            <li><a href="addProvider.jsp">Agregar Proveedor</a></li>
            <li><a href="registerEmployee.jsp">Registrar Empleado</a></li>
            <li><a href="logout.jsp">Cerrar Sesión</a></li>
        </ul>
    </nav>

    <% if ("success".equals(status)) { %>
        
    <% } else if ("failure".equals(status)) { %>
        <p style="color: red;">No se pudo eliminar el empleado. Inténtelo de nuevo.</p>
    <% } else if ("error".equals(status)) { %>
        <p style="color: red;">Error al conectar con la base de datos.</p>
    <% } %>

    <h2>Datos del Empleado</h2>
    <form action="RegisterEmployeeServlet" method="post">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Correo Electrónico:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Contraseña:</label>
        <input type="password" id="password" name="password" required><br><br>

        <label for="role">Rol:</label>
        <select id="role" name="role" required>
            <option value="employee">Empleado</option>
            <option value="admin">Administrador</option>
        </select><br><br>

        <input type="submit" value="Registrar Empleado">
    </form>

    <h2>Empleados Registrados</h2>
    <table>
        <tr>
            <th>Nombre</th>
            <th>Email</th>
            <th>Rol</th>
            <th>Acciones</th> <!-- Nueva columna para las acciones -->
        </tr>
        <% 
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                con = DatabaseConnection.initializeDatabase();
                String query = "SELECT * FROM users WHERE role = 'employee'";
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();
                
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("role") %></td>
            <td>
                <form action="DisableUserServlet" method="post">
                    <input type="hidden" name="userId" value="<%= rs.getInt("id") %>">
                    <input type="submit" value="Deshabilitar" class="disable-button">
                </form>
            </td>
        </tr>
        <% 
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("Error SQL al recuperar empleados: " + e.getMessage() + "<br>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Error al cerrar conexión: " + e.getMessage() + "<br>");
                }
            }
        %>
    </table>

</body>
</html>
