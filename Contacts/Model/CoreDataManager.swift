//
//  CoreDataManager.swift
//  Contacts
//
//  Created by 1606085 on 26/03/22.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager{
    
    func save(data:[Contacts]){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        for contact in data{
            let individual = NSManagedObject(entity: entity, insertInto: managedContext)
            individual.setValue(contact.name, forKey: "name")
            individual.setValue(contact.age, forKey: "age")
           // individual.setValue(contact.photo, forKey: "photo")
            individual.setValue(contact.phone, forKey: "phone")
            individual.setValue(contact.company, forKey: "company")
            individual.setValue(contact.id, forKey: "id")
            individual.setValue(contact.country, forKey: "country")
            individual.setValue(contact.zip, forKey: "zip")
            do{
                try managedContext.save()
            }
            catch let error as NSError{
                print("Unable to save the data \(error.userInfo)")
            }
        }
    }
}
