package com.cyberacy.negotrack.views.modals.add_task;

import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.*;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.stage.Stage;
import javafx.util.converter.NumberStringConverter;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class AddTaskController implements Initializable {
    public TextField name;
    public ComboBox<UserStory> cbUserStory;
    public ComboBox<Priority> cbPriority;
    public ComboBox<Severity> cbSeverity;
    public ComboBox<State> cbState;
    public TextArea description;
    public CheckBox isBug;
    public TextField nbTimeForecast;

    public void addTask(ActionEvent actionEvent) throws Exception {
        UserStory userStory = cbUserStory.getSelectionModel().getSelectedItem();
        Priority priority = cbPriority.getSelectionModel().getSelectedItem();
        Severity severity = cbSeverity.getSelectionModel().getSelectedItem();
        State state = cbState.getSelectionModel().getSelectedItem();

        if(name.getText().isEmpty() || priority == null || state == null || userStory == null || nbTimeForecast.getText() == null) {
            new ModalMessage("Formulaire invalide", "Le \"nom\", la \"user story\", la \"priorité\", le \"nombre d'heures prévu\" et l'\"état\" sont obligatoires").showModal();
            return;
        } else if(isBug.isSelected() && severity == null) {
            new ModalMessage("Formulaire invalide", "La \"sévérité\" est obligatoires en cas de bug").showModal();
            return;
        }
        Project currentProject = Singleton.getInstance().getCurrentProject();
        if(currentProject == null) {
            new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            return;
        }
        int nbTime = 0;
        try {
            nbTime = Integer.parseInt(nbTimeForecast.getText());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            new ModalMessage("Nombres d'heures invalide", "La saisie du \"nombre d'heures prévues\" est incorrete").showModal();
            return;
        }
        Integer idSeverity = (severity == null) ? 5 : severity.getId();
        Task.addTask(name.getText(), description.getText(), userStory.getId(), priority.getId(), idSeverity, isBug.isSelected(), nbTime, state.getId());
        Stage stage = (Stage) name.getScene().getWindow();
        stage.close();
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        nbTimeForecast.setTextFormatter(new TextFormatter<>(new NumberStringConverter()));
        Project currentProject = Singleton.getInstance().getCurrentProject();
        if (currentProject == null) {
            try {
                new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
        List<UserStory> userStories = UserStory.getAllUserStories(currentProject.getId());
        cbUserStory.setItems(FXCollections.observableArrayList(userStories));

        List<Priority> priorities = Priority.getAllPriority();
        cbPriority.setItems(FXCollections.observableArrayList(priorities));

        List<Severity> severities = Severity.getAllSeverity();
        cbSeverity.setItems(FXCollections.observableArrayList(severities));
        cbSeverity.setDisable(true);
        List<State> states = State.getAllStates();
        cbState.setItems(FXCollections.observableArrayList(states));
    }

    public void checkIsBuck(ActionEvent actionEvent) {
        cbSeverity.setDisable(!isBug.isSelected());
    }
}
