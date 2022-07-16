package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

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
}
