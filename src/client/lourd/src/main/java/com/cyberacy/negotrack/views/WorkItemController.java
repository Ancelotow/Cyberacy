package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Epic;
import com.cyberacy.negotrack.models.entities.Project;
import com.cyberacy.negotrack.models.entities.UserStory;
import com.cyberacy.negotrack.views.modals.add_epic.AddEpic;
import com.cyberacy.negotrack.views.modals.add_user_story.AddUserStory;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.control.cell.TextFieldListCell;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.HBox;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class WorkItemController implements Initializable {
    public ListView<Epic> listEpic;
    public List<Epic> epics;
    public List<UserStory> userStories;
    public ListView<UserStory> listUserStory;

    public void addEpic(ActionEvent actionEvent) {
        try {
            new AddEpic().showModal();
        } catch(Exception e){
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
    }

    public void addUserStory(ActionEvent actionEvent) {
        try {
            new AddUserStory().showModal();
        } catch(Exception e){
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        if(Singleton.getInstance().getCurrentProject() == null) {
            try {
                new ModalMessage("Projet courant inexistant", "Vous n'avez pas choisi de projet").showModal();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
        initListEpic();
        initListUserStory();
    }

    private void initListEpic(){
        epics = Epic.getAllEpic(Singleton.getInstance().getCurrentProject().getId());
        listEpic.getItems().clear();
        epics.forEach(epic -> listEpic.getItems().add(epic));
        listEpic.setEditable(false);
        listEpic.setCellFactory(this::editEpic);
    }

    private void initListUserStory(){
        userStories = UserStory.getAllUserStories(Singleton.getInstance().getCurrentProject().getId());
        listUserStory.getItems().clear();
        userStories.forEach(epic -> listUserStory.getItems().add(epic));
        listUserStory.setEditable(false);
        listUserStory.setCellFactory(this::editUserStory);
    }

    private ListCell<Epic> editEpic(ListView<Epic> epicListView) {
        return new ListCell<Epic>() {
            final private ImageView imageView = new ImageView();

            @Override
            public void updateItem(Epic item, boolean empty) {
                super.updateItem(item, empty);
                if(!empty && item != null) {
                    Image icoEpic = new Image(MainApplication.class.getResource("/images/icons/ic_epic.png").toString());
                    imageView.setImage(icoEpic);
                    imageView.setFitWidth(20.00);
                    imageView.setFitHeight(20.00);
                    setText(item.getName());
                    getStyleClass().add("txt-title-H3");
                    setGraphic(imageView);
                }
            }
        };
    }

    private ListCell<UserStory> editUserStory(ListView<UserStory> userStoryListView) {
        return new ListCell<UserStory>() {
            final private ImageView imageView = new ImageView();

            @Override
            public void updateItem(UserStory item, boolean empty) {
                super.updateItem(item, empty);
                if(!empty && item != null) {
                    Image icoEpic = new Image(MainApplication.class.getResource("/images/icons/ic_user_story.png").toString());
                    imageView.setImage(icoEpic);
                    imageView.setFitWidth(20.00);
                    imageView.setFitHeight(20.00);
                    setText(item.getName());
                    getStyleClass().add("txt-title-H3");
                    setGraphic(imageView);
                }
            }
        };
    }

}
