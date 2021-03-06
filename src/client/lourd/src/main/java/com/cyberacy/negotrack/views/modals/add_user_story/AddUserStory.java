package com.cyberacy.negotrack.views.modals.add_user_story;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.views.modals.AModal;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class AddUserStory extends AModal {

    private final Runnable callback;

    public AddUserStory(Runnable callback) {
        this.callback = callback;
    }

    @Override
    public void showModal() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                MainApplication.class.getResource("modal/add-user-story-view.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(MainApplication.class.getResource("/images/icon.png").toString());
        alert.getIcons().add(ico);
        alert.setTitle("Negotrack : Nouvelle user story");
        GridPane layout = alertLoader.load();
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 500)
        );
        alert.showAndWait();
        callback.run();
    }

}
