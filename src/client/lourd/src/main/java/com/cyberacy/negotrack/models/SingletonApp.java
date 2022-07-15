package com.cyberacy.negotrack.models;


import com.cyberacy.negotrack.MainApplication;
import javafx.application.Application;

public class SingletonApp {

    private static SingletonApp instance = null;
    final private MainApplication application;

    private SingletonApp(MainApplication application) {
        this.application = application;
    }

    public static void openSession(MainApplication application) {
        if(instance == null) {
            instance = new SingletonApp(application);
        }
    }

    public static void closeSession() {
        instance = null;
    }

    public static SingletonApp getInstance() {
        return instance;
    }

    public MainApplication getApplication() {
        return application;
    }

}
