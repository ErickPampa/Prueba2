package com.mycompany.presentacionfinal;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));

        HttpSession session = request.getSession();
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");

        if (cartItems != null && !cartItems.isEmpty()) {
            for (Map<String, Object> item : cartItems) {
                if (Integer.parseInt(item.get("productId").toString()) == productId) {
                    cartItems.remove(item);
                    break;
                }
            }
            session.setAttribute("cartItems", cartItems);
        }
    }
}
