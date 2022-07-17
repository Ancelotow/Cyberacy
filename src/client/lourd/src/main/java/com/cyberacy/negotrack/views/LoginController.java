package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.Singleton;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.views.modals.modal_message.ModalMessage;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.net.URL;
import java.util.ResourceBundle;

public class LoginController implements Initializable {

    @FXML
    public TextField login;
    @FXML
    public TextField password;
    public GridPane form;

    @FXML
    protected void connection() throws Exception {
        if(!login.getText().isEmpty() && !password.getText().isEmpty()) {
            Account account = Account.getAccount(login.getText(), password.getText());
            if(account == null) {
                new ModalMessage("Identifians invalide", "Votre identifiant et/ou mot de passe sont invalides.").showModal();
            } else {
                Singleton.getInstance().setAccount(account);
                Scene scene = this.form.getScene();
                ((Stage) scene.getWindow()).close();
                ((MainApplication) Singleton.getInstance().getApplication()).startMain();
            }
        } else {
            new ModalMessage("Formulaire incomplet", "Tout les champs sont obligatoires").showModal();
        }
    }

    @FXML
    protected void register(){
        try{
            Singleton.getInstance().getApplication().changeScene("register-view.fxml");
        }
        catch(Exception err){
            System.err.println(err.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
    }
}
