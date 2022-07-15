package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.models.exceptions.UniqueException;
import com.cyberacy.negotrack.views.modals.ModalMessage;
import javafx.event.ActionEvent;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;

public class RegisterController {
    public TextField login;
    public PasswordField password;
    public GridPane form;
    public TextField email;

    public void register(ActionEvent actionEvent) throws Exception {
        if(login.getText().isBlank() || password.getText().isBlank() || email.getText().isBlank()) {
            new ModalMessage("Formulaire incomplet", "Tout les champs sont obligatoires").showAlert();
            return;
        }
        try {
            Account.createAccount(login.getText(), password.getText(), email.getText());
            new ModalMessage("Création du compte", "Votre compté à été créé avec succès").showAlert();
        } catch (UniqueException ex) {
            new ModalMessage("Formulaire invalide", ex.getMessage()).showAlert();
        }
    }
}
