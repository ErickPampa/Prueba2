package com.mycompany.presentacionfinal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReserveOrderServlet")
public class ReserveOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerName = request.getParameter("customerName");
        String dni = request.getParameter("dni");
        String pickUpDateStr = request.getParameter("pickUpDate");

        // Formato de fecha
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date pickUpDate = sdf.parse(pickUpDateStr);
            Date currentDate = new Date();

            // Calcular la diferencia en días
            long diffInMillies = pickUpDate.getTime() - currentDate.getTime();
            long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

            // Validar que la fecha de recogida sea al menos 2 días después de la fecha actual
            if (diffInDays < 2) {
                response.getWriter().println("La fecha de recogida debe ser al menos 2 días después de la fecha actual.");
                return;
            }

        } catch (ParseException e) {
            e.printStackTrace();
            response.getWriter().println("Formato de fecha inválido.");
            return;
        }

        HttpSession session = request.getSession();
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");

        if (cartItems != null && !cartItems.isEmpty()) {
            double totalAmount = 0;
            StringBuilder orderDetails = new StringBuilder();

            for (Map<String, Object> item : cartItems) {
                String productName = (String) item.get("productName");
                int quantity = (int) item.get("quantity");
                double price = (double) item.get("productPrice");
                double itemTotal = quantity * price;
                totalAmount += itemTotal;
                orderDetails.append(productName).append(": $").append(price).append(" x ").append(quantity).append(" = $").append(itemTotal).append("<br>");
            }

            double taxAmount = totalAmount * 0.18;
            double grandTotal = totalAmount + taxAmount;

            try {
                Connection con = DatabaseConnection.initializeDatabase();
                if (con != null) {
                    String query = "INSERT INTO orders (customer_name, dni, pick_up_date, order_details, total_amount) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(query);
                    ps.setString(1, customerName);
                    ps.setString(2, dni);
                    ps.setString(3, pickUpDateStr);
                    ps.setString(4, orderDetails.toString());
                    ps.setDouble(5, grandTotal);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        // Guardar la información del pedido en la sesión
                        session.setAttribute("customerName", customerName);
                        session.setAttribute("pickUpDate", pickUpDateStr);

                        // Limpiar el carrito después de reservar el pedido
                        session.removeAttribute("cartItems");

                        // Redirigir a la página de confirmación
                        String contextPath = request.getContextPath();
                        response.sendRedirect(contextPath + "/confirmacion.jsp");
                    } else {
                        response.getWriter().println("No se pudo reservar el pedido en la base de datos.");
                    }

                    ps.close();
                    con.close();
                } else {
                    response.getWriter().println("No se pudo establecer conexión con la base de datos.");
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Error SQL al reservar pedido: " + e.getMessage());
            }
        } else {
            response.getWriter().println("El carrito de compras está vacío.");
        }
    }
}
