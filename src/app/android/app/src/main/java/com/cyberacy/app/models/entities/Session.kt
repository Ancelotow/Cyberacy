package com.cyberacy.app.models.entities


class Session private constructor(private val jwtToken: String) {

    companion object {
        private var instance: Session? = null

        fun openSession(token: String) {
            if(instance == null) {
                instance = Session(token)
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
                return instance!!.jwtToken
            }
            return ""
        }
    }





}