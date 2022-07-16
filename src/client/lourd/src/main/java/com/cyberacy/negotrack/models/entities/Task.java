package com.cyberacy.negotrack.models.entities;

import com.cyberacy.negotrack.models.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Task {

    private final int id;
    private final String name;
    private final String description;
    private final LocalDateTime dateCreated;
    private final LocalDateTime dateStart;
    private final LocalDateTime dateEnd;
    private final int nbTimeForecast;
    private final Integer nbTimeReal;
    private final boolean isBug;
    private final boolean isDeleted;
    private final LocalDateTime dateDeleted;
    private final boolean isArchived;
    private final LocalDateTime dateArchived;
    private final int idUserStory;
    private final int idState;
    private final int idPriority;
    private final Integer idSeverity;
    private final Integer idSprint;

    public Task(int id, String name, String description, LocalDateTime dateCreated, LocalDateTime dateStart, LocalDateTime dateEnd, int nbTimeForecast, Integer nbTimeReal, boolean isBug, boolean isDeleted, LocalDateTime dateDeleted, boolean isArchived, LocalDateTime dateArchived, int idUserStory, int idState, int idPriority, Integer idSeverity, Integer idSprint) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.dateCreated = dateCreated;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.nbTimeForecast = nbTimeForecast;
        this.nbTimeReal = nbTimeReal;
        this.isBug = isBug;
        this.isDeleted = isDeleted;
        this.dateDeleted = dateDeleted;
        this.isArchived = isArchived;
        this.dateArchived = dateArchived;
        this.idUserStory = idUserStory;
        this.idState = idState;
        this.idPriority = idPriority;
        this.idSeverity = idSeverity;
        this.idSprint = idSprint;
    }

    public static List<Task> getAllTasks(int idProject) {
        List<Task> tasks = new ArrayList<>();
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "SELECT DISTINCT tsk.* FROM task tsk JOIN user_story ust ON ust.ust_id = tsk.ust_id JOIN epic epi on ust.epi_id = epi.epi_id AND epi.prj_id = ?";
                PreparedStatement query = conn.prepareStatement(request);
                query.setInt(1, idProject);
                try (ResultSet result = query.executeQuery()) {
                    while (result.next()) {
                        int resId = result.getInt("tsk_id");
                        String resName = result.getString("tsk_name");
                        String resDescription = result.getString("tsk_description");
                        int resNbTimeForecast = result.getInt("tsk_nb_time_forecast");
                        int resNbTimeReal = result.getInt("tsk_nb_time_real");
                        boolean resIsBug = result.getBoolean("tsk_is_bug");
                        boolean resIsDeleted = result.getBoolean("tsk_is_delete");
                        boolean resIsArchived = result.getBoolean("tsk_is_archive");
                        int resIdUserStory = result.getInt("ust_id");
                        int resIdState = result.getInt("sta_id");
                        int resIdSprint = result.getInt("spr_id");
                        int resIdSeverity = result.getInt("sev_id");
                        int resIdPriority = result.getInt("pri_id");

                        Task task = new Task(resId, resName, resDescription, null, null, null, resNbTimeForecast, resNbTimeReal, resIsBug, resIsDeleted, null, resIsArchived, null, resIdUserStory, resIdState, resIdPriority, resIdSeverity, resIdSprint);
                        tasks.add(task);
                    }
                    query.close();
                }
            }
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
        return tasks;
    }

    public static void addTask(String name, String description, int idUserStory, int idPriority, Integer idSeverity, boolean isBug, int nbTimeForecast, int idState) {
        try {
            try (Connection conn = new ConnectDB().connect()) {
                String request = "INSERT INTO task(tsk_name, tsk_description, tsk_is_bug, tsk_nb_time_forecast, tsk_date_create, pri_id, sta_id, ust_id, sev_id) VALUES(?, ?, ?, ?, now(), ?, ?, ?, ?)";
                PreparedStatement query = conn.prepareStatement(request);
                query.setString(1, name);
                query.setString(2, description);
                query.setBoolean(3, isBug);
                query.setInt(4, nbTimeForecast);
                query.setInt(5, idPriority);
                query.setInt(6, idState);
                query.setInt(7, idUserStory);
                query.setInt(8, idSeverity);
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

    public LocalDateTime getDateStart() {
        return dateStart;
    }

    public LocalDateTime getDateEnd() {
        return dateEnd;
    }

    public int getNbTimeForecast() {
        return nbTimeForecast;
    }

    public Integer getNbTimeReal() {
        return nbTimeReal;
    }

    public boolean isBug() {
        return isBug;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public LocalDateTime getDateDeleted() {
        return dateDeleted;
    }

    public boolean isArchived() {
        return isArchived;
    }

    public LocalDateTime getDateArchived() {
        return dateArchived;
    }

    public int getIdUserStory() {
        return idUserStory;
    }

    public int getIdState() {
        return idState;
    }

    public int getIdPriority() {
        return idPriority;
    }

    public Integer getIdSeverity() {
        return idSeverity;
    }

    public Integer getIdSprint() {
        return idSprint;
    }
}
