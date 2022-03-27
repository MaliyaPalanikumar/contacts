//
//  CoreDataManager.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager{
    var appdelegate:AppDelegate?{
        
            return UIApplication.shared.delegate as? AppDelegate
        
        }
          
    var managedContext:NSManagedObjectContext{
    return appdelegate!.persistentContainer.viewContext
    }
    func save(data:[Contacts]){

       
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
    func fetch() ->[Contacts]?{
        var contact:[Contacts]?
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do{
            contact = try managedContext.fetch(fetchRequest) as! [Contacts]
            
        }
        catch let error as  NSError{
            print("Unable to fetch the record from the Core Data\(error.userInfo)")
        }
        return contact
    }
}
