<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<%
    HttpSession sessionObj = request.getSession();
    String customerName = (String) sessionObj.getAttribute("customerName");
    String pickUpDate = (String) sessionObj.getAttribute("pickUpDate");

    // Dirección y horario fijo
    String address = "Av. Latinoamérica 715, Lima";
    String schedule = "10:00 AM - 7:00 PM";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmación de Pedido</title>
    <link rel="stylesheet" type="text/css" href="assets/css/confirmacion-styles.css">
    <script>
        // Redirigir a index.html después de 20 segundos
        setTimeout(function() {
            window.location.href = 'index.html';
        }, 20000); // 20000 milisegundos = 20 segundos
    </script>
</head>
<body>
    <div class="confirmation-container">
        <h1>Confirmación de Pedido</h1>
        <div class="message-box">
            <p>¡Gracias por tu reserva, <%= customerName %>!</p>
            <p>Te esperamos el día <%= pickUpDate %> en la dirección <%= address %> desde las <%= schedule %>.</p>
            <p>Los métodos de pago disponibles son:</p>
            <ul>
                <li>Efectivo</li>
                <li>Yape</li>
            </ul>
            <p>¡Nos vemos pronto!</p>
            <p>Serás redirigido a la página de inicio en unos segundos...</p>
        </div>
    </div>
</body>
</html>
