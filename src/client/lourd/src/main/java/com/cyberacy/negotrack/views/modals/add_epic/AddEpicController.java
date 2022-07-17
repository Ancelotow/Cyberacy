package com.cyberacy.negotrack.views.modals.add_epic;

import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Epic;
import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.net.URL;
import java.util.ResourceBundle;

public class AddEpicController implements Initializable {
    public TextArea description;
    public TextField name;

    public void addEpic(ActionEvent actionEvent) throws Exception {
        if(name.getText().isEmpty()) {
            new ModalMessage("Formulaire invalide", "Le nom est obligatoire").showModal();
            return;
        }
        Project currentProject = Singleton.getInstance().getCurrentProject();
        if(currentProject == null) {
            new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            return;
        }
        Epic.AddEpic(name.getText(), description.getText(), currentProject.getId());
        Stage stage = (Stage) name.getScene().getWindow();
        stage.close();
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

    }
}
