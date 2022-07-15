package com.cyberacy.negotrack.views.modals;

import javafx.scene.Node;
import javafx.stage.Stage;

public abstract class AModal {

    public abstract void showModal() throws Exception;

    protected static void moveWindow(Node node, Stage stage){
        double[] xOffset = {0}, yOffset = {0};
        node.setOnMousePressed(event -> {
            xOffset[0] = (stage.getX() - event.getScreenX());
            yOffset[0] = (stage.getY() - event.getScreenY());
        });
        node.setOnMouseDragged(event -> {
            stage.setX(event.getScreenX() + xOffset[0]);
            stage.setY(event.getScreenY() + yOffset[0]);
        });
    }

}
