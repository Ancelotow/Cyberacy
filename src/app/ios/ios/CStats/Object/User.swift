//
//  User.swift
//  CStats
//
//  Created by Gabriel on 10/07/2022.
//

import Foundation

struct User: Codable {
    var code: Int
    var data: Data?
    var message: String?
    var status: String
    
}

struct Data: Codable {
    var address_street: String?
    var birthday: String?
    var email: String?
    var firstname: String?
    var lastname: String?
    var nir: String
    var profile: Int?
    var sex: Int?
    var token: String
    var town: String?
}
