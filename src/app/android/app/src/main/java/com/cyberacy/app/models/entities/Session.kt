package com.cyberacy.app.models.entities


class Session private constructor(private val person: Person) {

    companion object {
        private var instance: Session? = null

        fun openSession(person: Person) {
            if(instance == null) {
                instance = Session(person)
            }
        }

        fun closeSession() {
            instance = null
        }

        fun getSession(): Session? {
            return instance
        }

        fun getJwtToken(): String {
            if(instance != null) {
                return instance!!.person.token ?: ""
            }
            return ""
        }
    }





}