//
//  ItemList.swift
//  CStats
//
//  Created by Gabriel on 22/06/2022.
//

import Foundation

////
struct Message: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
    
}

struct Article: Decodable {
    var author: String?
    var title: String?
    var publishedAt: String?
}
/////////

// -> Politic party

// Adhérents

struct Adherent: Decodable{
    var status: String?
    var message: String?
    var code: Int?
    var data: [DataAdherent]
}

struct DataAdherent: Decodable{
    var id: Int
    var name: String
    var stats: [StatAd]
}

struct StatAd: Decodable {
    var year: Int
    var total: Int
    
}

struct AdherentM: Decodable{
    var status: String?
    var message: String?
    var code: Int?
    var data: [DataAdherentM]
}

struct DataAdherentM: Decodable{
    var id: Int
    var name: String
    var stats: [StatAdM]
}

struct StatAdM: Decodable {
    var id_political_party: Int
    var party_name: String
    var month: Int
    var year: Int
    var nb_adherent: Int
    
}

// Meet

struct Meeting: Decodable{
    var status: String?
    var message: String?
    var code: Int?
    var data: [DataMeet]
}

struct DataMeet: Decodable {
    var id: Int
    var name: String
    var stats: [Stat]
}

struct Stat: Decodable {
    var year: Int
    var total_participant: Int
    var total_meeting: Int
    
}



// -> Vote

// Participation

struct Participation: Decodable {
    var status: String?
    var message: String?
    var code: Int?
    var data: [DataParticipation]
}


struct DataParticipation: Decodable {
    var nb_participation: Int?
    var perc_participation: Int?
    var date_start: String?
    var id_election: Int?
    var name_election: String?
    var id_type_vote:Int?
    var name_type_vote: String?
}

// Abstention

struct Abstention: Decodable {
    var status: String?
    var message: String?
    var code: Int?
    var data: [DataAbstention]
}

struct DataAbstention: Decodable {
    var nb_abstention: Int
    var perc_abstention: Int?
    var date_start: String?
    var id_election: Int?
    var name_election: String
    var id_type_vote:Int?
    var name_type_vote: String?
}
