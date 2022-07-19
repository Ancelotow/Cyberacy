package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class State {

    private final int id;
    private final String name;
    private final int order;

    public State(int id, String name, int order) {
        this.id = id;
        this.name = name;
        this.order = order;
    }

    public static List<State> getAllStates() {
        List<State> states = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM state ORDER BY sta_order";
                PreparedStatement query = conn.prepareStatement(request);
                try(ResultSet result = query.executeQuery()) {
                    while(result.next()) {
                        int resId = result.getInt("sta_id");
                        String resName = result.getString("sta_name");
                        int resOrder = result.getInt("sta_order");
                        State state = new State(resId, resName, resOrder);
                        states.add(state);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return states;
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
