//
//  CstatesWebServices.swift
//  CStats
//
//  Created by Gabriel on 13/05/2022.
//

import Foundation
import UIKit

class CStatesWebServices{
    
    class func addUser(pseudo : String, email: String, password : String, name: String, surname: String, address: String, postal: String, date: Date,completion: @escaping (Error?, Bool?) -> Void){
        let token = "dAdw85L2Ta5LS76FM5E77zjKKsxwvn8Va36s3h2P6J6zBD7Zan"
        
        let url = "https://cyberacy.herokuapp.com/register"
        
        guard let getAddURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getAddURL)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = ["nir": pseudo,
                                   "firstname": surname,
                                   "lastname": name,
                                   "email": email,
                                   "password": password,
                                   "birthday": "1998-05-23",
                                   "address_street": address,
                                   "town_code_insee": "11003",
                                   "sex": 1,
                                   "profile": 1]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else {
                completion(err, false)
                return
            }
            guard let d = data else {
                completion(NSError(domain: "com.cyberacy.stats", code: 2, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No data found"
                ]), nil)
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                
                completion(nil, true)
            } catch let err {
                completion(err, false)
                return
            }

        }
        
        task.resume()
    }
    
    
    class func connectUser(pseudo : String, password : String,completion: @escaping (Error?, User?) -> (Void) ){
        let url = "https://cyberacy.herokuapp.com/login_stats"
        
        guard let getConnectURL = URL(string: url) else{
            return
        }
        
        var request = URLRequest(url: getConnectURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["nir": pseudo,
                                   "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else {
                completion(err, nil)
                return
            }
            guard let d = data else {
                completion(NSError(domain: "com.cyberacy.stats", code: 3, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No data found"
                ]), nil)
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: d)
                //print(user)
                
                if  (user.code == 200)
                {
                    UserSession.openSession(token: user.data!.token)
                }
                completion(nil, user)
                
            } catch let err {
                print("ok")
                completion(err, nil)
                return
            }

        }
        
        task.resume()
        
    }
    
    
    // Politic party
    
    
    //adherent
    
    class func getAdherent(sort:String, completion: @escaping ([DataAdherent]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/political_party/adherent?sort=" + sort
        
        guard let getURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            //print(res)
            
            do {
                var parsingData = try JSONDecoder().decode(Adherent.self, from: d)
                print(parsingData.data)
                completion(parsingData.data)
                //print(parsingData)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    class func getAdherentM(completion: @escaping ([DataAdherentM]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/political_party/adherent?sort=month"
        
        guard let getURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            //print(res)
            
            do {
                var parsingData = try JSONDecoder().decode(AdherentM.self, from: d)
                print(parsingData.data)
                completion(parsingData.data)
                //print(parsingData)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    //Meeting
    
    class func getMeet(completion: @escaping ([DataMeet]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/political_party/meeting?sort=year"
        
        guard let getURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            //print(res)
            
            do {
                let parsingData = try JSONDecoder().decode(Meeting.self, from: d)
                completion(parsingData.data)
                print(parsingData)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    class func getMeetDet(id: Int, completion: @escaping ([DataMeet]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/political_party/meeting?sort=year&idPoliticalParty=" + String(id)
        
        guard let getURL = URL(string: url) else{
            return
        }
        
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            print(res)
            
            do {
                let parsingData = try JSONDecoder().decode(Meeting.self, from: d)
                completion(parsingData.data)
                print(parsingData)
                
                
                
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    // Message
    
    //A retirer Après connexion
    
    class func MessStats(completion: @escaping ([Article]) -> ()) {
        
        let url = "https://newsapi.org/v2/everything?q=apple&from=2022-07-06&to=2022-07-06&sortBy=popularity&apiKey=0d01972daf4d44698395aa1a782520f6"
        
        guard let getURL = URL(string: url) else{
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: getURL){data, res, err in
            
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                print("ok1")
                print(json)
                let parsingData = try JSONDecoder().decode(Message.self, from: d)
                //let json = String(decoding: d, as: UTF8.self)
                //print(parsingData)
                completion(parsingData.articles)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    // Vote
    
    // Participation
    
    class func getParticipation(completion: @escaping ([DataParticipation]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/vote/participation"
        
        guard let getURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            //print(res)
            
            do {
                let parsingData = try JSONDecoder().decode(Participation.self, from: d)
                completion(parsingData.data)
                //print(parsingData)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    // Abstention
    
    class func getAbstention(completion: @escaping ([DataAbstention]) -> ()){
        let session = UserSession.getInstance()
        let token = "Bearer " + (session?.getToken())!
        let url = "https://cyberacy.herokuapp.com/statistics/vote/abstention"
        
        guard let getURL = URL(string: url) else{
            return
        }
        var request = URLRequest(url: getURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print(request)
        let task = URLSession.shared.dataTask(with: request){data, res, err in
            guard err == nil else {
                return
            }
            guard let d = data else {
                return
            }
            //print(res)
            
            do {
                let parsingData = try JSONDecoder().decode(Abstention.self, from: d)
                completion(parsingData.data)
                print(parsingData)
            } catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    
    
    
}
