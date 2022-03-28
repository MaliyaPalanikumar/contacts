//
//  ViewController.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import UIKit
import SwiftUI
import MessageUI
class ViewController: UIViewController {
    
    var contact:[Contacts]?
    var contentType:[ContactListType]?
    var blurVisualEffect:UIVisualEffectView?
    var activityIndicator:UIActivityIndicatorView?
    var dataprovider:DataProvider?
    var filterType = [Contacts]()
    var profilecell:ContactTableViewCell?

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataprovider = DataProvider(viewController:self)
        dataprovider?.getContact()
        searchbar.delegate = self
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
        cell.delegate = self
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
extension ViewController:MFMailComposeViewControllerDelegate{
    func sendMail(to recipient:String?)
    {
        
    let mailComposeVC = MFMailComposeViewController()
        if !MFMailComposeViewController.canSendMail(){
            let alert = UIAlertController(title: "Mail Box not Configured", message: "Please,configure your mail box", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "okay", style: .cancel, handler: {
                alert in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([recipient!])
        mailComposeVC.setSubject("Greeting from")
        mailComposeVC.setMessageBody("Hi", isHTML: false)
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchBar.text?.lowercased()
        if searchText?.count == 0{
            searchBar.text = ""
            searchBar.resignFirstResponder()
            dataprovider?.getContact()
        }
        filterType.removeAll()
        for contact in contentType!{
            let intermediate = contact.contact?.filter({
                $0.name?.lowercased().contains(searchText!) as! Bool
            })
            filterType.append(contentsOf: intermediate!)
        }
        dataprovider?.sortedContacts(contact: filterType)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        dataprovider?.getContact()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dataprovider?.getContact()
        tableview.reloadData()
    }
}
extension ViewController:ContactTableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    func performPhotoView(cell:ContactTableViewCell) {
        self.profilecell = cell
       var imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var customProfile:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profilecell!.profile.image = customProfile
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
