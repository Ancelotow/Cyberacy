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
    requires javax.persistence;
    requires java.sql;

    opens com.cyberacy.negotrack to javafx.fxml;
    exports com.cyberacy.negotrack;
    exports com.cyberacy.negotrack.views.modals;
}
