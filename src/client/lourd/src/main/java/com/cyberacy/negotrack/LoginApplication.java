package com.cyberacy.negotrack;

import com.cyberacy.negotrack.models.ConnectDB;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.io.IOException;

public class LoginApplication extends Application {

    @Override
    public void start(Stage stage) throws IOException {
        new ConnectDB().connect();
        FXMLLoader fxmlLoader = new FXMLLoader(LoginApplication.class.getResource("login-view.fxml"));
        Image ico = new Image(LoginApplication.class.getResource("/images/negotrack_icone.png").toString());
        Scene scene = new Scene(fxmlLoader.load(), 1000, 600);
        stage.getIcons().add(ico);
        stage.setTitle("Negotrack : Connexion");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
