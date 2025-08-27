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
    <title>Inventario</title>
    <link rel="stylesheet" type="text/css" href="assets/css/inventory-styles.css">
    <script>
        function makeEditable(td) {
            if (td.hasAttribute('data-editing')) {
                return;
            }
            td.setAttribute('data-editing', true);
            var originalContent = td.textContent;
            var input = document.createElement('input');
            input.type = 'text';
            input.value = originalContent;
            input.onblur = function() {
                td.removeAttribute('data-editing');
                var newContent = input.value;
                td.textContent = newContent;

                var row = td.parentElement;
                var id = row.getAttribute('data-id');
                var column = td.getAttribute('data-column');
                updateProduct(id, column, newContent);
            };
            td.textContent = '';
            td.appendChild(input);
            input.focus();
        }

        function updateProduct(id, column, value) {
            var form = document.createElement('form');
            form.method = 'post';
            form.action = 'EditProductServlet';
            form.style.display = 'none';

            var idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = id;
            form.appendChild(idInput);

            var columnInput = document.createElement('input');
            columnInput.type = 'hidden';
            columnInput.name = 'column';
            columnInput.value = column;
            form.appendChild(columnInput);

            var valueInput = document.createElement('input');
            valueInput.type = 'hidden';
            valueInput.name = 'value';
            valueInput.value = value;
            form.appendChild(valueInput);

            document.body.appendChild(form);
            form.submit();
        }

        function deleteProduct(id) {
            if (confirm("¿Está seguro de que desea eliminar este producto?")) {
                var form = document.createElement('form');
                form.method = 'post';
                form.action = 'DeleteProductServlet';

                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);

                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</head>
<body>
    <h1>Inventario</h1>
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

    <h2>Productos Disponibles</h2>
    <table>
        <tr>
            <th>Nombre</th>
            <th>Descripción</th>
            <th>Stock</th>
            <th>Precio Unitario</th>
            <th>Acciones</th>
        </tr>
        <% 
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                con = DatabaseConnection.initializeDatabase();
                String query = "SELECT * FROM products";
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();
                
                while (rs.next()) {
        %>
        <tr data-id="<%= rs.getInt("id") %>">
            <td data-column="name" ondblclick="makeEditable(this)"><%= rs.getString("name") %></td>
            <td data-column="description" ondblclick="makeEditable(this)"><%= rs.getString("description") %></td>
            <td data-column="stock" ondblclick="makeEditable(this)"><%= rs.getInt("stock") %></td>
            <td data-column="price" ondblclick="makeEditable(this)">$<%= rs.getDouble("price") %></td>
            <td>
                <button onclick="deleteProduct(<%= rs.getInt("id") %>);">Eliminar</button>
            </td>
        </tr>
        <% 
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("Error SQL al recuperar productos: " + e.getMessage() + "<br>");
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
