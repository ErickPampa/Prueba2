package com.mycompany.presentacionfinal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DatabaseConnection.initializeDatabase();
            if (con != null) {
                String query = "DELETE FROM products WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, id);

                ps.executeUpdate();

                ps.close();
                con.close();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/inventory.jsp");
    }
}
