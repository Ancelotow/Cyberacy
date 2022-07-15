package com.cyberacy.negotrack.views.modals;

import javafx.application.Application;
import javafx.event.EventHandler;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.input.MouseEvent;
import javafx.stage.Stage;

import java.net.URL;
import java.util.ResourceBundle;

public class ModalMessageControl implements Initializable {

    private String message = "MESSAGE";
    private String titre = "TITRE";
    public Button btnClose;
    public Label labelMessage;
    public Label labelTitle;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        try{
            btnClose.setOnMouseClicked(event -> {
                Node source = (Node) event.getSource();
                Stage stage = (Stage) source.getScene().getWindow();
                stage.close();
            });
        }
        catch(Exception err){
            System.err.println(err.getMessage());
        }
    }

    public void initAlert(String titre, String message){
        this.titre = titre;
        this.message = message;
    }

    public String getTitre(){
        return titre;
    }


    public String getMessage(){
        return message;
    }
}
