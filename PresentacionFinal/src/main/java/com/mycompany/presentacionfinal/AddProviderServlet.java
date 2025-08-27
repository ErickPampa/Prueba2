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

@WebServlet("/addProvider")
public class AddProviderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "INSERT INTO providers (name, email, phone, address) VALUES (?, ?, ?, ?)";
            PreparedStatement st = con.prepareStatement(query);
            st.setString(1, name);
            st.setString(2, email);
            st.setString(3, phone);
            st.setString(4, address);
            st.executeUpdate();

            st.close();
            con.close();

            response.sendRedirect("providers.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("addProvider.jsp?error=1");
        }
    }
}
