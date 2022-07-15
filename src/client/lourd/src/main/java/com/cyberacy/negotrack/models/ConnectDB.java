package com.cyberacy.negotrack.models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {

    private final String url = "jdbc:postgresql://cyberacy.postgres.database.azure.com/negotrack";
    private final String user = "cyberacy";
    private final String password = "7sA9h5Uc5TyT";

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }

}
