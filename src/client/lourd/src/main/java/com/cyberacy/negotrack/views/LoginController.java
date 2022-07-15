package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.Session;
import com.cyberacy.negotrack.models.SingletonApp;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.views.modals.ModalMessage;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
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
        if(!login.getText().isBlank() && !password.getText().isBlank()) {
            Account account = Account.getAccount(login.getText(), password.getText());
            if(account == null) {
                new ModalMessage("Identifians invalide", "Votre identifiant et/ou mot de passe sont invalides.").showAlert();
            } else {
                Session.openSession(account);
                Scene scene = this.form.getScene();
                ((Stage) scene.getWindow()).close();
                ((MainApplication) SingletonApp.getInstance().getApplication()).startMain();
            }
        } else {
            new ModalMessage("Formulaire incomplet", "Tout les champs sont obligatoires").showAlert();
        }
    }

    @FXML
    protected void register(){
        try{
            form.getChildren().remove(1);
            FXMLLoader userLoader = new FXMLLoader(
                    LoginController.class.getResource("register-view.fxml")
            );
            GridPane userRoot = userLoader.load();
            form.getChildren().add(1, userRoot);
        }
        catch(Exception err){
            System.err.println(err.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
    }
}
