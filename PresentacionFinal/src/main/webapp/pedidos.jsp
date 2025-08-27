<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<%
    String contextPath = request.getContextPath();
    HttpSession httpSession = request.getSession();
    List<Map<String, Object>> cartItems = (List<Map<String, Object>>) httpSession.getAttribute("cartItems");

    // Calcular total y detalles del carrito
    double totalAmount = 0;
    StringBuilder cartDetails = new StringBuilder();

    if (cartItems != null && !cartItems.isEmpty()) {
        for (Map<String, Object> item : cartItems) {
            String productName = (String) item.get("productName");
            double productPrice = (double) item.get("productPrice");
            int quantity = (int) item.get("quantity");
            double itemTotal = productPrice * quantity;
            totalAmount += itemTotal;
            cartDetails.append(productName).append(": $").append(String.format("%.2f", productPrice)).append(" x ").append(quantity).append(" = $").append(String.format("%.2f", itemTotal)).append("<br>");
        }
    }
    
    // Calcular IGV y total a pagar
    double taxAmount = totalAmount * 0.18;
    double grandTotal = totalAmount + taxAmount;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulario de Pedido</title>
    <link rel="stylesheet" type="text/css" href="assets/css/pedidos-styles.css">
    <script>
        window.onload = function() {
            // Obtener el campo de fecha
            var pickUpDateField = document.getElementById("pickUpDate");

            // Obtener la fecha actual
            var currentDate = new Date();

            // Agregar 3 días a la fecha actual
            currentDate.setDate(currentDate.getDate() + 3);

            // Formatear la fecha en el formato adecuado para el campo de fecha (yyyy-mm-dd)
            var year = currentDate.getFullYear();
            var month = ("0" + (currentDate.getMonth() + 1)).slice(-2);
            var day = ("0" + currentDate.getDate()).slice(-2);

            // Establecer la fecha mínima
            var minDate = year + "-" + month + "-" + day;
            pickUpDateField.min = minDate;
        };
    </script>
</head>
<body>
    <h1>Formulario de Pedido</h1>
    
    <form action="<%= contextPath %>/ReserveOrderServlet" method="post">
        <label for="customerName">Nombre Completo:</label>
        <input type="text" id="customerName" name="customerName" required><br><br>
        
        <label for="dni">DNI:</label>
        <input type="text" id="dni" name="dni" required><br><br>
        
        <label for="pickUpDate">Fecha de Recojo:</label>
        <input type="date" id="pickUpDate" name="pickUpDate" required><br><br>
        
        <h2>Detalle del Pedido</h2>
        <%= cartDetails.toString() %>
        
        <p>Total: $<%= String.format("%.2f", totalAmount) %></p>
        <p>IGV (18%): $<%= String.format("%.2f", taxAmount) %></p>
        <p>Total a Pagar: $<%= String.format("%.2f", grandTotal) %></p>
        
        <input type="submit" value="Reservar Pedido">
    </form>
</body>
</html>
