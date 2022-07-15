package com.cyberacy.negotrack;

import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.views.modals.ModalMessage;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Node;
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
    protected void connection() throws Exception {
        if(!login.getText().isBlank() && !password.getText().isBlank()) {
            Account account = Account.getAccount(login.getText(), password.getText());
            if(account == null) {
                new ModalMessage("Identifians invalide", "Votre identifiant et/ou mot de passe sont invalides.").showAlert();
            }
        } else {
            new ModalMessage("Formulaire incomplet", "Tout les champs sont obligatoires").showAlert();
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
    }
}
