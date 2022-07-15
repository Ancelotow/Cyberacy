package com.cyberacy.negotrack.views.modals;

import com.cyberacy.negotrack.LoginApplication;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class ModalMessage {

    private String message;
    private String title;

    public ModalMessage(String title, String message) {
        this.message = message;
        this.title = title;
    }

    public void showAlert() throws Exception {
        FXMLLoader alertLoader = new FXMLLoader(
                LoginApplication.class.getResource("modal/modal-message.fxml")
        );
        Stage alert = new Stage();
        Image ico = new Image(LoginApplication.class.getResource("/images/negotrack_icone.png").toString());
        alert.initStyle(StageStyle.UNDECORATED);
        alert.getIcons().add(ico);
        alert.setTitle(title);
        AnchorPane layout = alertLoader.load();
        ModalMessageControl controller = alertLoader.getController();
        controller.initAlert(title, message);
        layout.setStyle("-fx-background-color: #FFFFFF;");
        moveWindow(layout, alert);
        alert.setScene(
                new Scene(layout, 500, 200)
        );
        alert.showAndWait();
    }

    public static void moveWindow(Node node, Stage stage){
        double[] xOffset = {0}, yOffset = {0};
        node.setOnMousePressed(event -> {
            xOffset[0] = (stage.getX() - event.getScreenX());
            yOffset[0] = (stage.getY() - event.getScreenY());
        });
        node.setOnMouseDragged(event -> {
            stage.setX(event.getScreenX() + xOffset[0]);
            stage.setY(event.getScreenY() + yOffset[0]);
        });
    }

}
