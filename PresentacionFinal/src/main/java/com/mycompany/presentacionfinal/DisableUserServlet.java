import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mycompany.presentacionfinal.DatabaseConnection;

@WebServlet(name = "DisableUserServlet", urlPatterns = {"/DisableUserServlet"})
public class DisableUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("userId");
        
        if (userId == null || userId.isEmpty()) {
            response.sendRedirect(request.getHeader("referer") + "?status=failure");
            return;
        }
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Query para eliminar usuario por ID
            String query = "DELETE FROM users WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, userId);
            
            // Ejecutar la consulta
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect(request.getHeader("referer") + "?status=success");
            } else {
                response.sendRedirect(request.getHeader("referer") + "?status=failure");
            }
            
            // Cerrar recursos
            ps.close();
            con.close();
            
        } catch (ClassNotFoundException | SQLException e) {
            response.sendRedirect(request.getHeader("referer") + "?status=error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Disable User Servlet";
    }

}
