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

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String column = request.getParameter("column");
        String value = request.getParameter("value");

        try {
            Connection con = DatabaseConnection.initializeDatabase();
            if (con != null) {
                String query = "UPDATE products SET " + column + " = ? WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, value);
                ps.setInt(2, id);

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
