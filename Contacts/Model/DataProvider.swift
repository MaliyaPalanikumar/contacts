//
//  DataProvider.swift
//  Contacts
//
//  Created by Maliya on 27/03/22.
//

import Foundation
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
}
class DataProvider{
   
    
    let manager = CoreDataManager()
    var contact:[Contacts]?
    var sectionHeaders = [String]()
    var contactType = [ContactListType]()
    let coredataManager = CoreDataManager()
    let networkhandler = NetworkHandler()
    let delegate:DataProviderDelegate
    init(viewController:ViewController){
        self.delegate = viewController
        networkhandler.delegate = self
    }
    func getContact() {
       // if let contact = coredataManager.fetch(){
       //     self.contact = contact
       // }
        //else{
            networkhandler.loadData()
       // }
    }
    func sortedContacts(contact:[Contacts]?){
        self.contact = contact?.sorted(by: {
            $0.name?.localizedLowercase ?? "" < $1.name?.localizedLowercase ?? ""
        })
        if contact!.count > 0{
            sectionHeaders.append("#")
        }
        for contacts in self.contact!{
            if contacts.name != nil{
                let firstSymbol = contacts.name!.first
                if !self.sectionHeaders.contains(String(firstSymbol!)){
                    sectionHeaders.append(String(firstSymbol!))
                }
            }
            else{
               let firstSymbol = ""
                if !self.sectionHeaders.contains(String(firstSymbol)){
                    sectionHeaders.append(String(firstSymbol))
                }
            }
            
        }
        for firstLetter in sectionHeaders{
            let contacts = contact?.filter({
                String($0.name!.first!) == firstLetter
             })
           
            contactType.append(ContactListType(contact: contacts!, count: contacts!.count))
        }
        delegate.loadTableView(contacts:contactType)
    }
}
extension DataProvider:DataDowonloadedDelegate{
    
    func loadData(data:[Contacts]?) {
        guard let contact = data else{
            return
        }
        //self.loadCoreData(data:contact)
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
}
