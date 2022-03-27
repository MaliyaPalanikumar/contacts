//
//  NetworkHandler.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import Foundation
protocol DataDowonloadedDelegate{
    func loadData(data:[Contacts]?)
}
class NetworkHandler{
    let parser = JSONParser()
    
    var delegate:DataDowonloadedDelegate?
    enum Error:Swift.Error{
        case unknownAPIResponse
        case generic
    }
    let url = URL(string: "https://shielded-ridge-19050.herokuapp.com/api/?offset=10")
   
   
    func loadData(){
        
        if let url = url{
        let request = URLRequest(url: url)
        let session = URLSession.init(configuration: .default)
            session.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        return
                    }
                 
                self.delegate?.loadData(data:self.parser.parseJSON(from: data))
                }.resume()
        }
       
    }
   

}
