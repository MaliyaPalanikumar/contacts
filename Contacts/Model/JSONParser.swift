//
//  JSONParser.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import Foundation
import UIKit
struct Contacts:Decodable,Equatable{
    let name:String?
    let phone:String?
    let email:String?
    let address:String?
    let zip:String?
    let country:String?
    let id:Int?
    let company:String?
    let photo:URL?
    let age:Int?
  /*  init(name:String?,phone:String?,emailID:String?,address:String?,zip:String?,country:String?,id:Int?,company:String?,photo:URL?,age:Int?){
        self.name = name ?? "No Name"
        self.phone = phone
        self.email = emailID
        self.address = address
        self.zip = zip
        self.country = country
        self.id = id ?? 0
        self.company = company
        self.photo = photo
        self.age = age
        
    }*/
    
}
class JSONParser{

    func parseJSON(from data: Data) -> [Contacts]{
        var result:[Contacts]?
        do{
            result = try JSONDecoder().decode([Contacts].self, from: data)
                }
        catch{
            print(error.localizedDescription)
        }
        return result!
    }
    
    
   
   
}
