package com.mycompany.presentacionfinal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    public static Connection initializeDatabase() throws SQLException, ClassNotFoundException {
        // Especificar el controlador de la base de datos
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Crear la conexión
        String url = "jdbc:mysql://localhost:3306/ecommerce_db";
        String username = "root";
        String password = "";

        return DriverManager.getConnection(url, username, password);
    }
}
