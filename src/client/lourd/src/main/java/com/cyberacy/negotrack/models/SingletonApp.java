package com.cyberacy.negotrack.models;


import javafx.application.Application;

public class SingletonApp {

    private static SingletonApp instance = null;
    final private Application application;

    private SingletonApp(Application application) {
        this.application = application;
    }

    public static void openSession(Application application) {
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

    public Application getApplication() {
        return application;
    }

}
