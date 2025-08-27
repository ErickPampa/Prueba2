package com.mycompany.presentacionfinal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteOrderServlet")
public class DeleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement psInsert = null, psDelete = null;
        ResultSet rs = null;

        try {
            con = DatabaseConnection.initializeDatabase();

            // Obtener los detalles de la orden antes de eliminarla
            String querySelect = "SELECT * FROM orders WHERE id = ?";
            psInsert = con.prepareStatement(querySelect);
            psInsert.setInt(1, orderId);
            rs = psInsert.executeQuery();

            if (rs.next()) {
                // Insertar en sales_history
                String queryInsert = "INSERT INTO sales_history (order_id, customer_name, dni, pick_up_date, order_details, total_amount, order_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
                psInsert = con.prepareStatement(queryInsert);
                psInsert.setInt(1, rs.getInt("id"));
                psInsert.setString(2, rs.getString("customer_name"));
                psInsert.setString(3, rs.getString("dni"));
                psInsert.setDate(4, rs.getDate("pick_up_date"));
                psInsert.setString(5, rs.getString("order_details"));
                psInsert.setDouble(6, rs.getDouble("total_amount"));
                psInsert.setTimestamp(7, rs.getTimestamp("order_date"));
                psInsert.executeUpdate();
            }

            // Eliminar la orden de la tabla orders
            String queryDelete = "DELETE FROM orders WHERE id = ?";
            psDelete = con.prepareStatement(queryDelete);
            psDelete.setInt(1, orderId);
            psDelete.executeUpdate();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Error al eliminar la orden: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (psInsert != null) psInsert.close();
                if (psDelete != null) psDelete.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("orders.jsp");
    }
}
