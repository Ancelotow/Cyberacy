package com.cyberacy.negotrack;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.text.Text;

import java.io.File;
import java.net.URL;
import java.util.ResourceBundle;

public class LoginController implements Initializable {

    @FXML
    public TextField login;
    @FXML
    public TextField password;

    @FXML
    protected void connection() {
        if(login.getText().isBlank()) {
            login.getStyleClass().add("error-field");
        }
        if(password.getText().isBlank()) {
            password.getStyleClass().add("error-field");
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
    }
}
