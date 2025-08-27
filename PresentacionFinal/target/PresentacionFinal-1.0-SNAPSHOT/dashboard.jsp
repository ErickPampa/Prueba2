<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    <title>Dashboard</title>
    <link rel="stylesheet" type="text/css" href="assets/css/dashboard-styles.css">
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawCharts);

        function drawCharts() {
            drawSalesChartDaily();
            drawSalesChartMonthly();
            drawRevenueChartDaily();
            drawRevenueChartMonthly();
        }

        function drawSalesChartDaily() {
            var data = google.visualization.arrayToDataTable([
                ['Fecha', 'Ventas Diarias'],
                <% 
                    Connection con1 = null;
                    PreparedStatement ps1 = null;
                    ResultSet rs1 = null;

                    try {
                        con1 = DatabaseConnection.initializeDatabase();
                        String query1 = "SELECT DATE(order_date) as order_date, COUNT(*) as sales FROM sales_history GROUP BY DATE(order_date)";
                        ps1 = con1.prepareStatement(query1);
                        rs1 = ps1.executeQuery();

                        while (rs1.next()) {
                            String orderDate = rs1.getString("order_date");
                            int sales = rs1.getInt("sales");
                            out.println("['" + orderDate + "', " + sales + "],");
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("['Error', 0],");
                    } finally {
                        try {
                            if (rs1 != null) rs1.close();
                            if (ps1 != null) ps1.close();
                            if (con1 != null) con1.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            ]);

            var options = {
                title: 'Ventas Diarias',
                hAxis: {title: 'Fecha'},
                vAxis: {title: 'Ventas'}
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('sales_chart_daily'));
            chart.draw(data, options);
        }

        function drawSalesChartMonthly() {
            var data = google.visualization.arrayToDataTable([
                ['Mes', 'Ventas Mensuales'],
                <%
                    Connection con3 = null;
                    PreparedStatement ps3 = null;
                    ResultSet rs3 = null;

                    try {
                        con3 = DatabaseConnection.initializeDatabase();
                        String query3 = "SELECT MONTHNAME(order_date) as month, COUNT(*) as sales " +
                                        "FROM sales_history " +
                                        "GROUP BY MONTHNAME(order_date)";
                        ps3 = con3.prepareStatement(query3);
                        rs3 = ps3.executeQuery();

                        while (rs3.next()) {
                            String month = rs3.getString("month");
                            int sales = rs3.getInt("sales");
                            out.println("['" + month + "', " + sales + "],");
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("['Error', 0],");
                    } finally {
                        try {
                            if (rs3 != null) rs3.close();
                            if (ps3 != null) ps3.close();
                            if (con3 != null) con3.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            ]);

            var options = {
                title: 'Ventas Mensuales',
                hAxis: {title: 'Mes'},
                vAxis: {title: 'Ventas'}
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('sales_chart_monthly'));
            chart.draw(data, options);
        }

        function drawRevenueChartDaily() {
            var data = google.visualization.arrayToDataTable([
                ['Fecha', 'Ingresos Diarios'],
                <% 
                    Connection con2 = null;
                    PreparedStatement ps2 = null;
                    ResultSet rs2 = null;

                    try {
                        con2 = DatabaseConnection.initializeDatabase();
                        String query2 = "SELECT DATE(order_date) as order_date, SUM(total_amount) as revenue FROM sales_history GROUP BY DATE(order_date)";
                        ps2 = con2.prepareStatement(query2);
                        rs2 = ps2.executeQuery();

                        while (rs2.next()) {
                            String orderDate = rs2.getString("order_date");
                            double revenue = rs2.getDouble("revenue");
                            out.println("['" + orderDate + "', " + revenue + "],");
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("['Error', 0],");
                    } finally {
                        try {
                            if (rs2 != null) rs2.close();
                            if (ps2 != null) ps2.close();
                            if (con2 != null) con2.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            ]);

            var options = {
                title: 'Ingresos Diarios',
                hAxis: {title: 'Fecha'},
                vAxis: {title: 'Ingresos'}
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('revenue_chart_daily'));
            chart.draw(data, options);
        }

        function drawRevenueChartMonthly() {
            var data = google.visualization.arrayToDataTable([
                ['Mes', 'Ingresos Mensuales'],
                <%
                    Connection con4 = null;
                    PreparedStatement ps4 = null;
                    ResultSet rs4 = null;

                    try {
                        con4 = DatabaseConnection.initializeDatabase();
                        String query4 = "SELECT MONTHNAME(order_date) as month, SUM(total_amount) as revenue " +
                                        "FROM sales_history " +
                                        "GROUP BY MONTHNAME(order_date)";
                        ps4 = con4.prepareStatement(query4);
                        rs4 = ps4.executeQuery();

                        while (rs4.next()) {
                            String month = rs4.getString("month");
                            double revenue = rs4.getDouble("revenue");
                            out.println("['" + month + "', " + revenue + "],");
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("['Error', 0],");
                    } finally {
                        try {
                            if (rs4 != null) rs4.close();
                            if (ps4 != null) ps4.close();
                            if (con4 != null) con4.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            ]);

            var options = {
                title: 'Ingresos Mensuales',
                hAxis: {title: 'Mes'},
                vAxis: {title: 'Ingresos'}
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('revenue_chart_monthly'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>
    <h1>Dashboard de Ventas</h1>
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

    <div class="sales-charts">
        <div class="chart-container">
            <h2>Ventas Diarias</h2>
            <div id="sales_chart_daily"></div>
        </div>
        <div class="chart-container">
            <h2>Ventas Mensuales</h2>
            <div id="sales_chart_monthly"></div>
        </div>
    </div>

    <div class="revenue-charts">
        <div class="chart-container">
            <h2>Ingresos Diarios</h2>
            <div id="revenue_chart_daily"></div>
        </div>
        <div class="chart-container">
            <h2>Ingresos Mensuales</h2>
            <div id="revenue_chart_monthly"></div>
        </div>
    </div>
</body>
</html>
