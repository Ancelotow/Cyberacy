package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.*;

public class Account {

    final private int id;
    final private String pseudo;
    final private String email;

    public Account(int id, String pseudo, String email) {
        this.id = id;
        this.pseudo = pseudo;
        this.email = email;
    }

    public static Account getAccount(String pseudo, String password) {
        try {
            Account account = null;
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM account WHERE acc_pseudo = ? and acc_password = sha256(?::bytea)";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, pseudo);
                query.setString(2, password);
                try(ResultSet result = query.executeQuery()) {
                    System.out.println(result.next());
                    if(result.next()) {
                        int resId = result.getInt("acc_id");
                        String resPseudo = result.getString("acc_pseudo");
                        String resEmail = result.getString("acc_email");
                        account = new Account(resId, resPseudo, resEmail);
                    }
                    query.close();
                }
            }
            return account;
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
            return null;
        }
    }

    public int getId() {
        return id;
    }

    public String getPseudo() {
        return pseudo;
    }

    public String getEmail() {
        return email;
    }
}
