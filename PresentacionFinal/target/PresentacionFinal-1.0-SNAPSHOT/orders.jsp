<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
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
    <title>Órdenes de Compra</title>
    <link rel="stylesheet" type="text/css" href="assets/css/orders-styles.css">
    <script>
        function deleteOrder(id) {
            if (confirm("¿Está seguro de que desea eliminar esta orden de compra?")) {
                // Llamada a la función para actualizar el stock antes de eliminar la orden
                updateStock(id);

                // Creación del formulario para eliminar la orden
                var form = document.createElement('form');
                form.method = 'post';
                form.action = 'DeleteOrderServlet'; // Nombre del servlet de eliminación de órdenes
                form.style.display = 'none';

                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        function updateStock(orderId) {
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'UpdateStockServlet', true); // Nombre del servlet de actualización de stock
            xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            xhr.send('orderId=' + orderId);
        }
    </script>
</head>
<body>
    <h1>Órdenes de Compra</h1>
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

    <h2>Listado de Órdenes de Compra</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre del Cliente</th>
                <th>DNI</th>
                <th>Fecha de Recogida</th>
                <th>Detalles de la Orden</th>
                <th>Monto Total</th>
                <th>Fecha de Orden</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <% 
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    con = DatabaseConnection.initializeDatabase();
                    String query = "SELECT * FROM orders";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("dni") %></td>
                <td><%= rs.getString("pick_up_date") %></td>
                <td><%= rs.getString("order_details") %></td>
                <td>$<%= rs.getDouble("total_amount") %></td>
                <td><%= rs.getString("order_date") %></td>
                <td>
                    <button onclick="deleteOrder(<%= rs.getInt("id") %>);">Eliminar</button>
                </td>
            </tr>
            <% 
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.println("Error SQL al recuperar órdenes: " + e.getMessage() + "<br>");
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
        </tbody>
    </table>
</body>
</html>
