package com.cyberacy.negotrack.views.modals.add_task;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.views.modals.AModal;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class AddTask extends AModal {

    private final Runnable callback;

    public AddTask(Runnable callback) {
        this.callback = callback;
    }

    @Override
    public void showModal() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                MainApplication.class.getResource("modal/add-task-view.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(MainApplication.class.getResource("/images/icon.png").toString());
        alert.getIcons().add(ico);
        alert.setTitle("Negotrack : Nouvelle tâche");
        GridPane layout = alertLoader.load();
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 700)
        );
        alert.showAndWait();
        callback.run();
    }

}
