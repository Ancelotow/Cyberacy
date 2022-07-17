package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Severity {

    private final int id;
    private final String name;
    private final int order;

    public Severity(int id, String name, int order) {
        this.id = id;
        this.name = name;
        this.order = order;
    }

    public static List<Severity> getAllSeverity() {
        List<Severity> severities = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM severity ORDER BY sev_order";
                PreparedStatement query = conn.prepareStatement(request);
                try(ResultSet result = query.executeQuery()) {
                    while(result.next()) {
                        int resId = result.getInt("sev_id");
                        String resName = result.getString("sev_name");
                        int resOrder = result.getInt("sev_order");
                        Severity severity = new Severity(resId, resName, resOrder);
                        severities.add(severity);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return severities;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getOrder() {
        return order;
    }

    @Override
    public String toString() {
        return name;
    }

}
