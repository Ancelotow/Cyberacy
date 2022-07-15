//
//  Services.swift
//  CStats
//
//  Created by Gabriel on 26/06/2022.
//

import Foundation


public class UserSession {
    
    private static var instance: UserSession? = nil;
    private var token: String;

     private init(token: String) {
       self.token = token
     }

     static func openSession(token: String) {
       if(instance == nil) {
         instance = UserSession(token: token)
       }
     }

     static func closeSession() {
       instance = nil
     }

     static func getInstance() -> UserSession? {
       return instance
     }

     func getToken() -> String {
       return self.token
     }
    
}
