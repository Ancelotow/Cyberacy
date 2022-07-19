package com.cyberacy.negotrack.models;


import com.cyberacy.negotrack.MainApplication;
import com.cyberacy.negotrack.models.entities.Account;
import com.cyberacy.negotrack.models.entities.Project;

public class Singleton {

    private static Singleton instance = null;
    final private MainApplication application;
    private Account account;
    private Project currentProject;

    private Singleton(MainApplication application) {
        this.application = application;
    }

    public static void openSession(MainApplication application) {
        if(instance == null) {
            instance = new Singleton(application);
        }
    }

    public static void closeSession() {
        instance = null;
    }

    public static Singleton getInstance() {
        return instance;
    }

    public MainApplication getApplication() {
        return application;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Project getCurrentProject() {
        return currentProject;
    }

    public void setCurrentProject(Project currentProject) {
        this.currentProject = currentProject;
    }
}
