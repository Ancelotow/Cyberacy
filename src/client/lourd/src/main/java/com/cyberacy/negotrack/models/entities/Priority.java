package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Priority {

    private final int id;
    private final String name;
    private final int order;

    public Priority(int id, String name, int order) {
        this.id = id;
        this.name = name;
        this.order = order;
    }

    public static List<Priority> getAllPriority() {
        List<Priority> priorities = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM priority ORDER BY pri_order";
                PreparedStatement query = conn.prepareStatement(request);
                try(ResultSet result = query.executeQuery()) {
                    while(result.next()) {
                        int resId = result.getInt("pri_id");
                        String resName = result.getString("pri_name");
                        int resOrder = result.getInt("pri_order");
                        Priority priority = new Priority(resId, resName, resOrder);
                        priorities.add(priority);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return priorities;
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
