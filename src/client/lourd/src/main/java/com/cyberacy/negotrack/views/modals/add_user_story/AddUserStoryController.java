package com.cyberacy.negotrack.views.modals.add_user_story;

import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Epic;
import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.models.entities.UserStory;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class AddUserStoryController implements Initializable {
    public TextArea description;
    public TextField name;
    public ComboBox<Epic> cbEpic;

    public void addUserStory(ActionEvent actionEvent) throws Exception {
        Epic epic = cbEpic.getSelectionModel().getSelectedItem();
        if(name.getText().isEmpty() || epic == null) {
            new ModalMessage("Formulaire invalide", "Le \"nom\" et l'\"epic\" sont obligatoires").showModal();
            return;
        }
        Project currentProject = Singleton.getInstance().getCurrentProject();
        if(currentProject == null) {
            new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            return;
        }
        UserStory.AddUserStory(name.getText(), description.getText(), epic.getId());
        Stage stage = (Stage) name.getScene().getWindow();
        stage.close();
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        Project currentProject = Singleton.getInstance().getCurrentProject();
        if(currentProject == null) {
            try {
                new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
        List<Epic> epics = Epic.getAllEpic(currentProject.getId());
        cbEpic.setItems(FXCollections.observableArrayList(epics));
    }
}
