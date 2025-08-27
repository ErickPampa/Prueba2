package com.mycompany.presentacionfinal;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/AddProductServlet")
@MultipartConfig
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int stock = Integer.parseInt(request.getParameter("stock"));
        double price = Double.parseDouble(request.getParameter("price"));
        String fileName = "";

        Part filePart = request.getPart("image");
        if (filePart != null) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (!fileName.isEmpty()) {
                // Validar el nombre del archivo aquí si es necesario

                InputStream fileContent = filePart.getInputStream();
                File uploadsDir = new File(getServletContext().getRealPath("/uploads"));
                uploadsDir.mkdirs(); // Asegura que el directorio exista
                File file = new File(uploadsDir, fileName);
                
                try (OutputStream outputStream = new FileOutputStream(file)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                    response.getWriter().println("Error al guardar archivo: " + ex.getMessage());
                    return;
                }
            }
        }

        try {
            Connection con = DatabaseConnection.initializeDatabase();
            if (con != null) {
                con.setAutoCommit(false); // Habilitar transacciones

                String insertQuery = "INSERT INTO products (name, description, stock, price, image) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(insertQuery)) {
                    ps.setString(1, name);
                    ps.setString(2, description);
                    ps.setInt(3, stock);
                    ps.setDouble(4, price);
                    ps.setString(5, fileName);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        // Obtener el ID del producto insertado (si es necesario)
                        // ResultSet generatedKeys = ps.getGeneratedKeys();
                        // int productId = generatedKeys.getInt(1);

                        // Agregar el producto al carrito en la sesión
                        HttpSession session = request.getSession();
                        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");

                        if (cartItems == null) {
                            cartItems = new ArrayList<>();
                        }

                        Map<String, Object> item = new HashMap<>();
                        item.put("productName", name);
                        item.put("productPrice", price);
                        item.put("quantity", 1); // Puedes ajustar esto según necesites

                        cartItems.add(item);
                        session.setAttribute("cartItems", cartItems);

                        // Confirmar la transacción
                        con.commit();

                        // Redirigir a inventory.jsp después de procesar el formulario
                        String contextPath = request.getContextPath();
                        response.sendRedirect(contextPath + "/inventory.jsp");
                    } else {
                        response.getWriter().println("No se pudo insertar el producto en la base de datos.");
                    }
                } catch (SQLException e) {
                    con.rollback(); // Revertir la transacción si ocurre un error
                    throw e; // Lanzar la excepción para manejarla más arriba si es necesario
                } finally {
                    con.setAutoCommit(true); // Restaurar el modo de autocommit por defecto
                }
            } else {
                response.getWriter().println("No se pudo establecer conexión con la base de datos.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error SQL al insertar producto: " + e.getMessage());
        }
    }
}
