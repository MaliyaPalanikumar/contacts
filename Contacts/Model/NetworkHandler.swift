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
    let session = URLSession.init(configuration: .default)
    let queue = OperationQueue()
    var delegate:DataDowonloadedDelegate?
    enum Error:Swift.Error{
        case unknownAPIResponse
        case generic
    }
    let url = URL(string: "https://shielded-ridge-19050.herokuapp.com/api/?offset=49")
   
   
    func loadData(){
        queue.addOperation { [self] in
            if let url = url{
            let request = URLRequest(url: url)
                for i in 0...50{
                let task = session.dataTask(with: request) { data, response, error in
                        guard let data = data else {
                            return
                        }
                     
                    self.delegate?.loadData(data:self.parser.parseJSON(from: data))
                    }
                task.resume()
                }
        }
        }
    }
       
    func downloadProfileImage(from url:URL?,completionHandler:@escaping (Data) ->Void){
        guard let url = url else {
            return
        }

       session.dataTask(with: URLRequest(url:url)){ data, response, error in
            guard let data = data,error == nil else {
                return
            }
            completionHandler(data)

        }.resume()
       
        }
    
   

}
