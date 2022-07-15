package com.cyberacy.negotrack.models;

import com.cyberacy.negotrack.models.entities.Account;

public class Session {

    private static Session instance = null;
    final private Account account;

    private Session(Account account) {
        this.account = account;
    }

    public static void openSession(Account account) {
        if(instance == null) {
            instance = new Session(account);
        }
    }

    public static void closeSession() {
        instance = null;
    }

    public static Session getInstance() {
        return instance;
    }

    public Account getAccount() {
        return account;
    }

}
