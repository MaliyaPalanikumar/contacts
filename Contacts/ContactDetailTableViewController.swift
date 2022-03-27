//
//  ContactDetailTableViewController.swift
//  Contacts
//
//  Created by 1606085 on 27/03/22.
//

import Foundation
import SwiftUI
enum CellType{
    case phone,email,address
}
struct ContactDetailTableViewController:View{
    var contact:Contacts?
    var image:UIImage?
    var dataprovider:DataProvider?
    @Environment(\.presentationMode) private var presentationMode
    var body: some View{
       
        List{
            BasicDetail(contact: contact, image: image)
            Section {
               
                NumberCell(contact: contact, field: CellType.phone)
            } header: {
                Text("Phone")
            }
            Section {
                
                NumberCell(contact: contact, field: CellType.email)
            } header: {
                Text("Email")
            }
            Section {
                NumberCell(contact: contact, field: CellType.address)
            } header: {
                Text("Address")
            }
            Group{
                Spacer()
                Button(action: {
                    dataprovider?.makeCall(number:contact?.phone)
                }){
                    Image(uiImage: UIImage(named: "btab_icn_phone")!)
                }
                Spacer()
                Button(action: {
                    dataprovider?.sendMail(email:contact?.email)
                }){
                    Image(uiImage: UIImage(named: "btab_icn_mail")!)
                }
                Spacer()
                Button(action: {
                    dataprovider?.deleteContact(contact: contact!)
                    self.presentationMode.wrappedValue.dismiss()
                    
                }){
                    Image(uiImage: UIImage(named: "btab_icn_delete")!)
                }
                Spacer()

            }
           
               
            
    }


        }
   

struct BasicDetail:View{
    var contact:Contacts?
    var image:UIImage?
    var body: some View{
        if let contact = contact {
            HStack{
                Image(uiImage: image!)

            VStack{
                Text(contact.name!)
                Text(contact.company!)
            }
            }
        }
        
    }
    
}
struct NumberCell:View{
    var contact:Contacts?
    var field:CellType
    var body: some View{
        switch(field){
        case CellType.phone:
            Text((contact?.phone)!)
        case CellType.email:
            Text((contact?.email) ?? "No Email")
        case CellType.address:
            Text((contact?.country)!)
            Text((contact?.zip)!)
           
        }
        
    }
}

struct ContactDetailTableViewPreview:PreviewProvider{
    static var previews: some View{
        ContactDetailTableViewController()
    }
}
}
