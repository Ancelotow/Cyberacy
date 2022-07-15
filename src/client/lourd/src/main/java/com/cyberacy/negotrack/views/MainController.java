package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.models.Session;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.views.modals.add_project.AddProject;
import javafx.event.ActionEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

public class MainController {

    public Account account = Session.getInstance().getAccount();

    public HBox hbMain;

    public void addProject(ActionEvent actionEvent) {
        try {
            new AddProject().showModal();
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
    }
}
