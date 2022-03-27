//
//  ViewController.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var contact:[Contacts]?
    var contentType:[ContactListType]?
    var blurVisualEffect:UIVisualEffectView?
    var activityIndicator:UIActivityIndicatorView?
    var dataprovider:DataProvider?

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataprovider = DataProvider(viewController:self)
        dataprovider?.getContact()
        addBlurEffect()
        
    }


}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        (contentType?.count)! - 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentType![section].sectionCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        dataprovider!.downloadImage(image: contentType![indexPath.section].contact![indexPath.row].photo!) { data in
            DispatchQueue.main.async {
                cell.profile.image =   UIImage(data: data) ?? UIImage(named: "list-no-thb")
               
            }}
       
       
        cell.name.text = contentType![indexPath.section].contact![indexPath.row].name!
        cell.company.text = contentType![indexPath.section].contact![indexPath.row].company!
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataProvider.sectionHeaders[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailedImage:UIImage?
        dataprovider!.downloadImage(image: contentType![indexPath.section].contact![indexPath.row].photo!) { data in
            DispatchQueue.main.async {
               detailedImage = UIImage(data: data) ?? UIImage(named: "list-no-thb")
                let detailedViewController = UIHostingController(rootView: ContactDetailTableViewController(contact: self.contentType![indexPath.section].contact![indexPath.row],image: detailedImage!,dataprovider:self.dataprovider))
               
                self.navigationController?.pushViewController(detailedViewController, animated: true)
            }}
       
    }
   
}
extension ViewController:DataProviderDelegate{
    func loadTableView(contacts:[ContactListType]){
       
       
        DispatchQueue.main.async {
            self.removeBlurEffect()
            self.contentType = contacts
            self.tableview.delegate = self
            self.tableview.dataSource = self
            self.tableview.reloadData()
        }
       
        
       
    }
    func addBlurEffect(){
       let blureffect = UIBlurEffect(style: .light)
        blurVisualEffect = UIVisualEffectView(effect: blureffect)
        blurVisualEffect?.frame = self.tableview.bounds
        blurVisualEffect?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.tableview.addSubview(blurVisualEffect!)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.startAnimating()
        activityIndicator?.center = self.tableview.center
        self.tableview.addSubview(activityIndicator!)
    }
    func removeBlurEffect(){
        DispatchQueue.main.async {
            self.blurVisualEffect?.removeFromSuperview()
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
           
        
        
    }
}

