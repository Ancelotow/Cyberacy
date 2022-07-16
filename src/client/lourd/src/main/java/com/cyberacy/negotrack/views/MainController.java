package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.Session;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.views.modals.add_project.AddProject;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.SeparatorMenuItem;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class MainController implements Initializable {

    public Account account = Session.getInstance().getAccount();

    public HBox hbMain;
    public Menu menu;
    public Button btnKanban;

    public void addProject(ActionEvent actionEvent) {
        try {
            new AddProject().showModal();
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
    }

    public void selectProject(Project project) {
        try {
            menu.setText(project.getName());
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try{
            List<Project> projects = Project.getAllProjects();
            projects.forEach(project -> {
                MenuItem item = new MenuItem(project.getName());
                item.setOnAction((event) ->  selectProject(project));
                menu.getItems().add(item);
            });
            menu.getItems().add(new SeparatorMenuItem());
            MenuItem itemAddProject = new MenuItem("Ajouter un projet");
            itemAddProject.setOnAction(this::addProject);
            menu.getItems().add(itemAddProject);
        } catch(Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void goToKanban(ActionEvent actionEvent) {
        try{
            hbMain.getChildren().remove(1);
            FXMLLoader fxmlLoader = new FXMLLoader(
                    MainApplication.class.getResource("kanban-view.fxml")
            );
            hbMain.getChildren().add(1, fxmlLoader.load());
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

    }
}
