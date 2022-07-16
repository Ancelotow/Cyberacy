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

public class UserStory {

    final private int id;
    final private String name;
    final private String description;
    final private LocalDateTime dateCreated;
    final private int epicId;

    public UserStory(int id, String name, String description, LocalDateTime dateCreated, int epicId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.dateCreated = dateCreated;
        this.epicId = epicId;
    }

    public static void AddUserStory(String name, String description, int idEpic) {
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "INSERT INTO user_story(ust_name, ust_description, ust_date_create, epi_id) VALUES(?, ?, now(), ?)";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, name);
                query.setString(2, description);
                query.setInt(3, idEpic);
                query.executeUpdate();
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
    }

    public static List<UserStory> getAllUserStories(int idProject) {
        List<UserStory> userStories = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT DISTINCT ust.* FROM user_story ust JOIN epic epi ON ust.epi_id = epi.epi_id AND epi.prj_id = ?";
                PreparedStatement query = conn.prepareStatement(request);
                query.setInt(1, idProject);
                try(ResultSet result = query.executeQuery()) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS");
                    while(result.next()) {
                        int resIdEpic = result.getInt("epi_id");
                        int resId = result.getInt("ust_id");
                        String resName = result.getString("ust_name");
                        String resDescription = result.getString("ust_description");
                        String resDateCreate = result.getString("ust_date_create");

                        UserStory userStory = new UserStory(resId, resName, resDescription, LocalDateTime.now(), resIdEpic);
                        userStories.add(userStory);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return userStories;
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

    public int getEpicId() {
        return epicId;
    }
}
