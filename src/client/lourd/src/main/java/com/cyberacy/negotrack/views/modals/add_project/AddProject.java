package com.cyberacy.negotrack.views.modals.add_project;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.views.modals.AModal;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessageController;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class AddProject extends AModal {

    @Override
    public void showModal() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                MainApplication.class.getResource("modal/add-project-modal.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(MainApplication.class.getResource("/images/negotrack_icone.png").toString());
        //alert.initStyle(StageStyle.UNDECORATED);
        alert.getIcons().add(ico);
        alert.setTitle("Negotrack : Nouveau projet");
        GridPane layout = alertLoader.load();
        //layout.setStyle("-fx-background-color: #96969f;");
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 500)
        );
        alert.showAndWait();
    }

}
