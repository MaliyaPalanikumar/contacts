//
//  NetworkHandler.swift
//  Contacts
//
//  Created by 1606085 on 26/03/22.
//

import Foundation
class NetworkHandler{
    let parser = JSONParser()
    var contacts:[Contacts]?
    enum Error:Swift.Error{
        case unknownAPIResponse
        case generic
    }
    let url = URL(string: "https://shielded-ridge-19050.herokuapp.com/api/?offset=10")
   
   
    func loadData() -> Void{
        if let url = url{
        let request = URLRequest(url: url)
        let session = URLSession.init(configuration: .default)
            session.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        return
                    }
                self.contacts = self.parser.parseJSON(from: data)
                }.resume()
        }
       
    }

}
