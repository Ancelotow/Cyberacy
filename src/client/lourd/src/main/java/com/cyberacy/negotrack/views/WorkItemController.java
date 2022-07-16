package com.cyberacy.negotrack.views;

import com.cyberacy.negotrack.views.modals.add_epic.AddEpic;
import javafx.event.ActionEvent;

public class WorkItemController {
    public void addEpic(ActionEvent actionEvent) {
        try {
            new AddEpic().showModal();
        } catch(Exception e){
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
    }
}
