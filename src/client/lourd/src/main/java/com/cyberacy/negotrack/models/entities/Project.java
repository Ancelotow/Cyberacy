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

public class Project {

    final private int id;
    final private String name;
    final private LocalDateTime dateCreated;
    final private String description;

    public Project(int id, String name, LocalDateTime dateCreated, String description) {
        this.id = id;
        this.name = name;
        this.dateCreated = dateCreated;
        this.description = description;
    }

    public static List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT * FROM project";
                PreparedStatement query = conn.prepareStatement(request);
                try(ResultSet result = query.executeQuery()) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS");
                    while(result.next()) {
                        int resId = result.getInt("prj_id");
                        String resName = result.getString("prj_name");
                        String resDescription = result.getString("prj_description");
                        String resDateCreate = result.getString("prj_datecreate");
                        LocalDateTime dateCreate = null;
                        try{
                            dateCreate = LocalDateTime.parse(resDateCreate, formatter);
                        } catch (DateTimeParseException e) {
                            System.err.println(e.getMessage());
                        }
                        Project project = new Project(resId, resName, dateCreate, resDescription);
                        projects.add(project);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return projects;
    }

    public static void AddProject(String name, String description) {
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "INSERT INTO project(prj_name, prj_datecreate, prj_description) VALUES(?, now(), ?)";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, name);
                query.setString(2, description);
                try(ResultSet result = query.executeQuery()) {
                    query.close();
                }
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

    public LocalDateTime getDateCreated() {
        return dateCreated;
    }

    public String getDescription() {
        return description;
    }
}
