package com.mycompany.presentacionfinal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));

        HttpSession session = request.getSession();
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");

        if (cartItems == null) {
            cartItems = new ArrayList<>();
        }

        // Verificar si el producto ya está en el carrito
        boolean found = false;
        for (Map<String, Object> item : cartItems) {
            if (Integer.parseInt(item.get("productId").toString()) == productId) {
                int quantity = (int) item.get("quantity");
                item.put("quantity", quantity + 1);
                found = true;
                break;
            }
        }

        if (!found) {
            Map<String, Object> item = new HashMap<>();
            item.put("productId", productId);
            item.put("productName", productName);
            item.put("productPrice", productPrice);
            item.put("quantity", 1); // Inicialmente 1 unidad
            cartItems.add(item);
        }

        session.setAttribute("cartItems", cartItems);
    }
}
