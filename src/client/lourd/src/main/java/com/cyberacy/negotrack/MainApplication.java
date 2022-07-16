package com.cyberacy.negotrack;

import com.cyberacy.negotrack.models.ConnectDB;
import com.cyberacy.negotrack.models.Session;
import com.cyberacy.negotrack.models.SingletonApp;
import com.cyberacy.negotrack.views.MainController;
import javafx.application.Application;
import javafx.event.EventHandler;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;

import java.io.IOException;
import java.util.Objects;

public class MainApplication extends Application {

    Stage primaryStage;

    @Override
    public void start(Stage stage) throws IOException {
        primaryStage = stage;
        SingletonApp.openSession(this);
        FXMLLoader fxmlLoader = new FXMLLoader(MainApplication.class.getResource("login-view.fxml"));
        Image ico = new Image(Objects.requireNonNull(MainApplication.class.getResource("/images/negotrack_icone.png")).toString());
        Scene scene = new Scene(fxmlLoader.load(), 1000, 600);
        stage.getIcons().add(ico);
        stage.setTitle("Negotrack : Connexion");
        stage.setScene(scene);
        stage.show();
    }

    public void startMain() {
        try {
            primaryStage = new Stage();
            FXMLLoader mainLoader = new FXMLLoader(getClass().getResource("main-view.fxml"));
            GridPane root = mainLoader.load();
            MainController controller = (MainController) mainLoader.getController();
            Image ico = new Image(Objects.requireNonNull(MainApplication.class.getResource("/images/negotrack_icone.png")).toString());
            primaryStage.getIcons().add(ico);
            primaryStage.setTitle("Negotrack : " + Session.getInstance().getAccount().getPseudo());
            Scene scene = new Scene(root, 1500, 800);
            primaryStage.setScene(scene);
            primaryStage.show();
        } catch (Exception err) {
            System.err.println(err.getMessage());
        }
    }

    public void changeScene(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource(fxml));
        Scene newScene = new Scene(fxmlLoader.load(), primaryStage.getScene().getWidth(), primaryStage.getScene().getHeight());
        primaryStage.setScene(newScene);
    }

    public static void main(String[] args) {
        launch();
    }
}
