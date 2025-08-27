package com.mycompany.presentacionfinal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.mycompany.presentacionfinal.DatabaseConnection;

@WebServlet("/UpdateStockServlet")
public class UpdateStockServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        Connection con = null;
        PreparedStatement getSalesPs = null;
        ResultSet getSalesRs = null;

        try {
            con = DatabaseConnection.initializeDatabase();

            // Obtener las ventas de sales_history para la orden específica
            String getSalesQuery = "SELECT * FROM sales_history WHERE order_id = ?";
            getSalesPs = con.prepareStatement(getSalesQuery);
            getSalesPs.setInt(1, orderId);
            getSalesRs = getSalesPs.executeQuery();

            while (getSalesRs.next()) {
                String orderDetails = getSalesRs.getString("order_details");

                // Analizar los detalles de la orden para obtener los productos y cantidades
                String[] items = orderDetails.split("<br>");

                for (String item : items) {
                    // Obtener el nombre del producto y la cantidad comprada
                    String productName = extractProductName(item);
                    int quantity = extractQuantity(item);

                    if (productName != null && quantity > 0) {
                        // Consultar el ID y stock del producto basado en el nombre
                        String getProductQuery = "SELECT id, stock FROM products WHERE name = ?";
                        PreparedStatement getProductPs = con.prepareStatement(getProductQuery);
                        getProductPs.setString(1, productName);
                        ResultSet getProductRs = getProductPs.executeQuery();

                        if (getProductRs.next()) {
                            int productId = getProductRs.getInt("id");
                            int currentStock = getProductRs.getInt("stock");

                            // Calcular el nuevo stock
                            int newStock = currentStock - quantity;

                            // Actualizar el stock del producto en la tabla products
                            String updateProductQuery = "UPDATE products SET stock = ? WHERE id = ?";
                            PreparedStatement updateProductPs = con.prepareStatement(updateProductQuery);
                            updateProductPs.setInt(1, newStock);
                            updateProductPs.setInt(2, productId);
                            updateProductPs.executeUpdate();
                            updateProductPs.close();
                        }

                        getProductRs.close();
                        getProductPs.close();
                    }
                }
            }

            // Envía una respuesta de éxito si es necesario
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            // Cerrar conexiones y recursos
            try {
                if (getSalesRs != null) getSalesRs.close();
                if (getSalesPs != null) getSalesPs.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Método para extraer el nombre del producto de la cadena de detalles de la orden
    private String extractProductName(String item) {
        String[] parts = item.split(":");
        if (parts.length > 0) {
            return parts[0].trim();
        }
        return null;
    }

    // Método para extraer la cantidad del producto de la cadena de detalles de la orden
    private int extractQuantity(String item) {
        String[] parts = item.split(":");
        if (parts.length > 1) {
            String quantityStr = parts[1].trim().split(" ")[0]; // Obtener el número antes de " x"
            return Integer.parseInt(quantityStr);
        }
        return 0;
    }
}
