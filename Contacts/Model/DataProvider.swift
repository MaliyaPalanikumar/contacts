//
//  DataProvider.swift
//  Contacts
//
//  Created by Maliya on 27/03/22.
//

import Foundation
import UIKit
class ContactListType{
    var contact:[Contacts]?
    var sectionCount:Int
    init(contact:[Contacts]?,count:Int){
        self.contact = contact
        self.sectionCount = count
    }
}
protocol DataProviderDelegate{
    func loadTableView(contacts:[ContactListType])
    func sendMail(to recipient:String?)
}
class DataProvider{
   
    
    let manager = CoreDataManager()
    var contact:[Contacts]?
    static var sectionHeaders = [String]()
    var contactType = [ContactListType]()
    let coredataManager = CoreDataManager()
    let networkhandler = NetworkHandler()
    let delegate:DataProviderDelegate
    init(viewController:ViewController){
        self.delegate = viewController
        networkhandler.delegate = self
    }
    func getContact() {
        if let contact = coredataManager.fetch(){
          self.contact = contact
          self.sortedContacts(contact:contact)
       }
        else{
            networkhandler.loadData()
       }
    }
    func sortedContacts(contact:[Contacts]?){
        
        self.contact = contact?.sorted(by: {
            $0.name?.localizedLowercase ?? "" < $1.name?.localizedLowercase ?? ""
        })
        if contact!.count > 0{
            DataProvider.sectionHeaders.append("#")
        }
        for contacts in self.contact!{
            if contacts.name != nil{
                let firstSymbol = contacts.name!.first
                if !DataProvider.sectionHeaders.contains(String(firstSymbol!)){
                    DataProvider.sectionHeaders.append(String(firstSymbol!))
                }
            }
            else{
               let firstSymbol = ""
                if !DataProvider.sectionHeaders.contains(String(firstSymbol)){
                    DataProvider.sectionHeaders.append(String(firstSymbol))
                }
            }
            
        }
        contactType.removeAll()
        for firstLetter in DataProvider.sectionHeaders{
            
            let contacts = contact?.filter({
                String($0.name!.first!) == firstLetter
             })
           
            contactType.append(ContactListType(contact: contacts!, count: contacts!.count))
        }
        
        delegate.loadTableView(contacts:contactType)
    }
    func downloadImage(image:URL,completionHandler:@escaping (Data) -> Void){
        
        networkhandler.downloadProfileImage(from: image) { data in
           completionHandler(data)
        }
        
}
}
extension DataProvider:DataDowonloadedDelegate{
   
    func loadData(data:[Contacts]?) {
        guard let contact = data else{
            return
        }
        self.loadCoreData(data:contact)
        self.sortedContacts(contact:contact)
    }
    
}
extension DataProvider{
    func loadCoreData(data:[Contacts]?){
        guard let data = data else{
            return
        }
       self.manager.save(data:data)
    }
    func deleteContact(contact:Contacts){
        self.manager.delete(id:contact.id!)
        let mutablearray = NSMutableArray(array: self.contact!)
        for contacts in mutablearray{
            if contacts as! Contacts == contact{
                mutablearray.remove(contacts)
              
            }
        }
        self.sortedContacts(contact: mutablearray as? [Contacts])
    }
    
}
extension DataProvider{
    func sendMail(email:String?){
        delegate.sendMail(to:email)
    }
    func makeCall(number:String?){
        if let url = URL(string: "tel://\(number!)"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
}
