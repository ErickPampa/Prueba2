package com.mycompany.presentacionfinal;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String action = request.getParameter("action");

        HttpSession session = request.getSession(true);
        Map<Integer, Map<String, Object>> cartItems = (Map<Integer, Map<String, Object>>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new HashMap<>();
        }

        if ("add".equals(action)) {
            int id = Integer.parseInt(productId);
            if (cartItems.containsKey(id)) {
                Map<String, Object> item = cartItems.get(id);
                int quantity = (int) item.get("quantity");
                item.put("quantity", quantity + 1);
            } else {
                // Aquí obtendrías el producto de la base de datos si es necesario
                // Para simplificar, solo guardamos el ID y la cantidad por ahora
                Map<String, Object> newItem = new HashMap<>();
                newItem.put("productId", id);
                newItem.put("quantity", 1);
                cartItems.put(id, newItem);
            }
        } else if ("remove".equals(action)) {
            int id = Integer.parseInt(productId);
            cartItems.remove(id);
        }

        session.setAttribute("cartItems", cartItems);
        response.sendRedirect("catalog.jsp");
    }
}
