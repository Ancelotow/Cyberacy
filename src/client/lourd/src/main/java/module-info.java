module com.cyberacy.negotrack {
    requires javafx.controls;
    requires javafx.fxml;
    requires javafx.web;

    requires org.controlsfx.controls;
    requires com.dlsc.formsfx;
    requires validatorfx;
    requires org.kordamp.ikonli.javafx;
    requires org.kordamp.bootstrapfx.core;
    requires eu.hansolo.tilesfx;
    requires java.sql;

    opens com.cyberacy.negotrack to javafx.fxml;
    opens com.cyberacy.negotrack.views to javafx.fxml;
    exports com.cyberacy.negotrack;
    exports com.cyberacy.negotrack.views;
    exports com.cyberacy.negotrack.views.modals.modal_message;
    exports com.cyberacy.negotrack.views.modals.add_project;
    exports com.cyberacy.negotrack.views.modals.add_epic;
}
