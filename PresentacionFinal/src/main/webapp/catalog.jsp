<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.mycompany.presentacionfinal.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Catálogo de Productos</title>
    <link rel="stylesheet" type="text/css" href="assets/css/catalog-styles.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f3f6f8;
            margin: 0;
            padding: 0;
        }

        h1 {
            background-color: #FE6960;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 30px;
            width: 100%; /* Ajuste para que el título ocupe todo el ancho */
        }

        .content-wrapper {
            display: flex;
            justify-content: space-between;
            padding: 20px;
        }

        .product-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: flex-start;
            margin-bottom: 30px;
        }

        .product-item {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: calc(25% - 20px); /* Aproximadamente 4 productos por fila */
            text-align: center;
            margin-bottom: 20px;
        }

        .product-item img {
            max-width: 100%;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .product-item h2 {
            color: #FE6960;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .product-item p {
            color: #666666;
            margin-bottom: 10px;
        }

        .product-item button {
            background-color: #FE6960;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .product-item button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }

        .product-item button:hover {
            background-color: #ff4d4d;
        }

        .cart-container {
            flex: 1;
            border: 1px solid #ccc;
            padding: 10px;
            margin-top: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        .cart-container h2 {
            color: #FE6960;
            font-size: 24px;
            margin-bottom: 10px;
            text-align: center;
        }

        .cart-container button {
            background-color: #FE6960;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            display: block;
            margin: 0 auto;
        }

        .cart-container button:hover {
            background-color: #ff4d4d;
        }

        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item button {
            background-color: #FE6960;
            color: white;
            border: none;
            padding: 5px 10px;
            font-size: 14px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .cart-item button:hover {
            background-color: #ff4d4d;
        }
        .product-container {
    width: calc(75% - 20px); /* Ajustar para que quepan 3 productos por fila */
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between; /* Ajuste para espacio uniforme */
    gap: 20px; /* Espacio uniforme entre productos */
    margin-bottom: 30px;
}

.product-item {
    flex-basis: calc(30% - 20px); /* Aproximadamente 3 productos por fila */
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
    text-align: center;
}

.cart-container {
    width: calc(25% - 20px); /* Ajustar al ancho del carrito de compras */
    padding: 10px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    margin-left: 20px; /* Agregar un margen izquierdo para separar del product-container */
    margin-top: 20px; /* Añadir un espacio entre los contenedores */
}

.cart-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #eee;
}

.cart-item:last-child {
    border-bottom: none;
}

.cart-item .item-name {
    flex: 1;
}

.cart-item .item-quantity {
    margin-right: 10px;
}

.cart-item button {
    background-color: #FE6960;
    color: white;
    border: none;
    padding: 5px 10px;
    font-size: 14px;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}





    </style>
    <script>
        function addToCart(productId, productName, productPrice) {
            var cartContainer = document.getElementById('cart_container');
            var existingItem = document.querySelector('#cart_container [data-id="' + productId + '"]');
            var quantity = 1; // Puedes ajustar esto según necesites, por defecto añade uno

            // Verificar si el producto ya está en el carrito y obtener la cantidad actual
            if (existingItem) {
                var currentQuantity = parseInt(existingItem.getAttribute('data-quantity'));
                var stock = parseInt(document.getElementById('stock_' + productId).textContent.trim());
                
                if (currentQuantity < stock) {
                    quantity = currentQuantity + 1;
                    existingItem.setAttribute('data-quantity', quantity);
                    existingItem.querySelector('.item-quantity').textContent = quantity;
                } else {
                    alert('¡No hay suficiente stock disponible!');
                }
            } else {
                var newItem = document.createElement('div');
                newItem.classList.add('cart-item');
                newItem.setAttribute('data-id', productId);
                newItem.setAttribute('data-quantity', quantity);
                newItem.innerHTML = '<span class="item-name">' + productName + '</span>' +
                                    '<span class="item-quantity">' + quantity + '</span>' +
                                    '<button onclick="removeFromCart(' + productId + ')">Eliminar</button>';
                cartContainer.appendChild(newItem);
            }

            // AJAX para guardar en sesión
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'AddToCartServlet', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send('productId=' + productId + '&productName=' + encodeURIComponent(productName) + '&productPrice=' + productPrice);
        }

        function removeFromCart(productId) {
            var itemToRemove = document.querySelector('#cart_container [data-id="' + productId + '"]');
            if (itemToRemove) {
                itemToRemove.parentNode.removeChild(itemToRemove);

                // AJAX para eliminar de sesión
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'RemoveFromCartServlet', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.send('productId=' + productId);
            }
        }

        function continueToCheckout() {
            // Implementar la lógica para redirigir a la página de checkout (pedidos.jsp)
            window.location.href = 'pedidos.jsp';
        }

        // Función para verificar y deshabilitar botones según el stock disponible
        function checkStockAvailability() {
            var productItems = document.querySelectorAll('.product-item');
            productItems.forEach(function(item) {
                var productId = item.getAttribute('data-id');
                var stock = parseInt(document.getElementById('stock_' + productId).textContent.trim());
                var addButton = item.querySelector('button');

                if (stock === 0) {
                    addButton.disabled = true;
                    addButton.textContent = 'Sin Stock';
                }
            });
        }

        // Llamar a la función al cargar la página para verificar el stock inicialmente
        window.onload = function() {
            checkStockAvailability();
        };
    </script>
</head>
<body>
    <h1>Catálogo de Productos</h1>

    <div class="content-wrapper">
        <div class="product-container">
            <% 
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DatabaseConnection.initializeDatabase();
                    String query = "SELECT * FROM products WHERE stock > 0"; // Solo productos con stock mayor a 0
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();

                    while (rs.next()) {
            %>
            <div class="product-item" data-id="<%= rs.getInt("id") %>">
                <img src="uploads/<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>">
                <h2><%= rs.getString("name") %></h2>
                <p>Precio: $<%= rs.getDouble("price") %></p>
                <p>Stock: <span id="stock_<%= rs.getInt("id") %>"><%= rs.getInt("stock") %></span></p>
                <button onclick="addToCart(<%= rs.getInt("id") %>, '<%= rs.getString("name") %>', <%= rs.getDouble("price") %>)">Añadir al Carrito</button>
            </div>
            <% 
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.println("Error SQL al recuperar productos: " + e.getMessage() + "<br>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("Error al cerrar conexión: " + e.getMessage() + "<br>");
                    }
                }
            %>
        </div>

        <div class="cart-container">
            <h2>Carrito de Compras</h2>
            <div id="cart_container">
                <!-- Aquí se añadirán dinámicamente los elementos del carrito -->
            </div>
            <button onclick="continueToCheckout()">Continuar con la Compra</button>
        </div>
    </div>
</body>
</html>
