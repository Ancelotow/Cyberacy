package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.views.modals.add_project.AddProject;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.SeparatorMenuItem;
import javafx.scene.layout.GridPane;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class MainController implements Initializable {

    public Account account = Singleton.getInstance().getAccount();

    public Menu menu;
    public Button btnKanban;
    public Button btnWorkItem;
    public GridPane gridMain;

    public void addProject(ActionEvent actionEvent) {
        try {
            new AddProject(this::initListProjects).showModal();
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
    }

    public void selectProject(Project project) {
        try {
            Singleton.getInstance().setCurrentProject(project);
            btnKanban.setVisible(true);
            btnWorkItem.setVisible(true);
            menu.setText(project.getName());
        } catch(Exception e){
            System.err.println(e.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try{
            btnKanban.setVisible(false);
            btnWorkItem.setVisible(false);
            initListProjects();
        } catch(Exception e) {
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
    }

    private void initListProjects() {
        menu.getItems().clear();
        List<Project> projects = Project.getAllProjects();
        projects.forEach(project -> {
            MenuItem item = new MenuItem(project.getName());
            item.setOnAction((event) ->  selectProject(project));
            menu.getItems().add(item);
        });
        menu.getItems().add(new SeparatorMenuItem());
        MenuItem itemAddProject = new MenuItem(" + Nouveau projet");
        itemAddProject.setOnAction(this::addProject);
        menu.getItems().add(itemAddProject);
    }

    public void goToKanban(ActionEvent actionEvent) {
        try{
            changeView("kanban-view.fxml");
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
    }

    public void goToWorkItem(ActionEvent actionEvent) {
        try{
            changeView("work-item-view.fxml");
        } catch (IOException e) {
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
    }

    private void changeView(String fxml) throws IOException {
        ObservableList<Node> childrens = gridMain.getChildren();
        for(Node node : childrens) {
            if(node != null) {
                if(GridPane.getColumnIndex(node) == 1) {
                    //GridPane imageView= ImageView(node); // use what you want to remove
                    gridMain.getChildren().remove(node);
                    break;
                }
            }

        }
        FXMLLoader fxmlLoader = new FXMLLoader(
                MainApplication.class.getResource(fxml)
        );
        gridMain.add(fxmlLoader.load(), 1, 0);
    }
}
