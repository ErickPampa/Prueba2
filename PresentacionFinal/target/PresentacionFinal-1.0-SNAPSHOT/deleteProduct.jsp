<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<%
    String productId = request.getParameter("id");
    if (productId == null || productId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Si no se proporciona un ID válido
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = DatabaseConnection.initializeDatabase();
        String query = "DELETE FROM products WHERE id=?";
        ps = con.prepareStatement(query);
        ps.setString(1, productId);
        ps.executeUpdate();
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Redireccionar de vuelta a la página de inventario después de eliminar el producto
    response.sendRedirect("inventory.jsp");
%>
