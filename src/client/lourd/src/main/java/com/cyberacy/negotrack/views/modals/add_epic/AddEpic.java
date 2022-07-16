package com.cyberacy.negotrack.views.modals.add_epic;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.views.modals.AModal;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class AddEpic extends AModal {

    @Override
    public void showModal() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                MainApplication.class.getResource("modal/add-epic.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(MainApplication.class.getResource("/images/negotrack_icone.png").toString());
        alert.getIcons().add(ico);
        alert.setTitle("Negotrack : Nouvel epic");
        GridPane layout = alertLoader.load();
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 500)
        );
        alert.showAndWait();
    }

}
