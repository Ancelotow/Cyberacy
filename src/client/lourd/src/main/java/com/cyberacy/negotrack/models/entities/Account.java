package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;
import com.cyberacy.negotrack.models.exceptions.UniqueException;

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

    public static void createAccount(String pseudo, String password, String email) throws UniqueException {
        try {
            try (Connection conn = new ConnectDB().connect()) {
                if(ifExistsPseudo(pseudo)) {
                    throw new UniqueException(String.format("Le pseudo \"%s\" éxiste déjà", pseudo));
                }
                String request = "INSERT INTO account(acc_pseudo, acc_email, acc_password) VALUES(?, ?, sha256(?::bytea))";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, pseudo);
                query.setString(2, email);
                query.setString(3, password);
                query.executeUpdate();
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
    }

    public static Boolean ifExistsPseudo(String pseudo) {
        try {
            boolean isExists = false;
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM account WHERE acc_pseudo = ?";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, pseudo);
                try(ResultSet result = query.executeQuery()) {
                    isExists = result.next();
                    query.close();
                }
            }
            return isExists;
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
            return false;
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
