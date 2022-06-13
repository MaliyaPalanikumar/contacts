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
    var contact: [NSManagedObject] = []
    func save(data:[Contacts]){

       
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        for contact in data{
            let individual = NSManagedObject(entity: entity, insertInto: managedContext)
            individual.setValue(contact.name, forKey: "name")
            individual.setValue(contact.age, forKey: "age")
            individual.setValue(contact.photo, forKey: "photo")
            individual.setValue(contact.phone, forKey: "phone")
            individual.setValue(contact.company, forKey: "company")
            individual.setValue(contact.id, forKey: "id")
            individual.setValue(contact.country, forKey: "country")
            individual.setValue(contact.zip, forKey: "zip")
            individual.setValue(contact.email, forKey: "email")
            individual.setValue(contact.address, forKey: "address")
            
            do{
                try managedContext.save()
            }
            catch let error as NSError{
                print("Unable to save the data \(error.userInfo)")
            }
        }
    }
    func fetch() ->[Contacts]?{
        var fetchResult = [Contacts]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do{
            self.contact = try managedContext.fetch(fetchRequest)
            
            guard contact.count > 0 else{
                return nil
            }
            for contact in contact {
                fetchResult.append(Contacts(
                 name: contact.value(forKey: "name") as? String,
                 phone: contact.value(forKey: "phone")  as? String,
                 email: contact.value(forKey: "email") as? String,
                 address: contact.value(forKey: "address") as? String,
                 zip: contact.value(forKey: "zip") as? String,
                 country: contact.value(forKey: "country") as? String,
                 id: contact.value(forKey: "id") as? Int,
                 company: contact.value(forKey: "company") as? String,
                 photo: contact.value(forKey: "photo") as? URL,
                 age: contact.value(forKey: "age") as? Int))
                
            }
            
        }
        catch let error as  NSError{
            print("Unable to fetch the record from the Core Data\(error.userInfo)")
        }
        return fetchResult
    }
    func delete(id:Int){
        let fetchRequest:NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do{
            let result = try managedContext.fetch(fetchRequest)
                for result in result {
                    managedContext.delete(result)
                }

        }
        catch let error as NSError{
            print("Unable to delete\(error.userInfo)")
        }
    }
}
