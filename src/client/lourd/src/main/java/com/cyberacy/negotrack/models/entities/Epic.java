package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

public class Epic {

    final private int id;
    final private String name;
    final private String description;
    final private LocalDateTime dateCreated;
    final private int idProject;

    public Epic(int id, String name, String description, LocalDateTime dateCreated, int idProject) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.dateCreated = dateCreated;
        this.idProject = idProject;
    }

    public static void AddEpic(String name, String description, int idProject) {
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "INSERT INTO epic(epi_name, epi_description, epi_date_create, prj_id) VALUES(?, ?, now(), ?)";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, name);
                query.setString(2, description);
                query.setInt(3, idProject);
                query.executeUpdate();
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
    }

    public static List<Epic> getAllEpic(int idProject) {
        List<Epic> epics = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM epic where prj_id = ?";
                PreparedStatement query = conn.prepareStatement(request);
                query.setInt(1, idProject);
                try(ResultSet result = query.executeQuery()) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS");
                    while(result.next()) {
                        int resIdProject = result.getInt("prj_id");
                        int resId = result.getInt("epi_id");
                        String resName = result.getString("epi_name");
                        String resDescription = result.getString("epi_description");
                        String resDateCreate = result.getString("epi_date_create");

                        Epic epic = new Epic(resId, resName, resDescription, LocalDateTime.now(), resIdProject);
                        epics.add(epic);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return epics;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public LocalDateTime getDateCreated() {
        return dateCreated;
    }

    public int getIdProject() {
        return idProject;
    }

    @Override
    public String toString() {
        return name;
    }
}
