package com.cyberacy.negotrack.views.modals.modal_message;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.views.modals.AModal;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class ModalMessage extends AModal {

    private String message;
    private String title;

    public ModalMessage(String title, String message) {
        this.message = message;
        this.title = title;
    }

    @Override
    public void showModal() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                MainApplication.class.getResource("modal/modal-message.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(MainApplication.class.getResource("/images/negotrack_icone.png").toString());
        //alert.initStyle(StageStyle.UNDECORATED);
        alert.getIcons().add(ico);
        alert.setTitle(title);
        AnchorPane layout = alertLoader.load();
        ModalMessageController controller = alertLoader.getController();
        controller.initAlert(title, message);
        //layout.setStyle("-fx-background-color: #888aab;");
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 200)
        );
        alert.showAndWait();
    }

}
