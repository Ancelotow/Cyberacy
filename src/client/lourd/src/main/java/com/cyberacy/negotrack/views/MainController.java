package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.models.Session;
import com.cyberacy.negotrack.models.entities.Account;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

public class MainController {

    public Account account = Session.getInstance().getAccount();

    public HBox hbMain;
}
