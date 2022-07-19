package com.cyberacy.negotrack.views.modals.add_project;

import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.Window;

import java.net.URL;
import java.util.ResourceBundle;

public class AddProjectController implements Initializable {

    @FXML
    public TextField name;
    @FXML
    public TextArea description;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

    }

    public void addProject() throws Exception {
        if(name.getText().isEmpty()) {
            new ModalMessage("Formulaire invalide", "Le nom est obligatoire").showModal();
            return;
        }
        Project.AddProject(name.getText(), description.getText());
        Stage stage = (Stage) name.getScene().getWindow();
        stage.close();
    }
}
