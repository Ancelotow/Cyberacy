package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.models.exceptions.UniqueException;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.event.ActionEvent;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;

public class RegisterController {
    public TextField login;
    public PasswordField password;
    public GridPane form;
    public TextField email;

    public void register() throws Exception {
        if(login.getText().isEmpty() || password.getText().isEmpty() || email.getText().isEmpty()) {
            new ModalMessage("Formulaire incomplet", "Tout les champs sont obligatoires").showModal();
            return;
        }
        try {
            Account.createAccount(login.getText(), password.getText(), email.getText());
            new ModalMessage("Création du compte", "Votre compté à été créé avec succès").showModal();
        } catch (UniqueException ex) {
            new ModalMessage("Formulaire invalide", ex.getMessage()).showModal();
        }
    }


    public void goToConnexion() {
        try{
            Singleton.getInstance().getApplication().changeScene("login-view.fxml");
        }
        catch(Exception err){
            System.err.println(err.getMessage());
        }
    }

}
