//
//  ViewController.swift
//  Contacts
//
//  Created by Maliya on 26/03/22.
//

import UIKit

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
        (contentType?.count)!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentType![section].sectionCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        cell.name.text = contentType![indexPath.section].contact![indexPath.row].name!
        cell.company.text = contentType![indexPath.section].contact![indexPath.row].company!
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataprovider!.sectionHeaders[section]
    }
   
}
extension ViewController:DataProviderDelegate{
    func loadTableView(contacts:[ContactListType]){
       
        removeBlurEffect()
        self.contentType = contacts
        DispatchQueue.main.sync {
            self.tableview.delegate = self
            self.tableview.dataSource = self
            self.tableview.reloadData()
        }
       
    }
    func addBlurEffect(){
        let blureffect = UIBlurEffect(style: .light)
        blurVisualEffect = UIVisualEffectView(effect: blureffect)
        blurVisualEffect?.frame = self.view.bounds
        blurVisualEffect?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.view.addSubview(blurVisualEffect!)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.startAnimating()
        self.view.addSubview(activityIndicator!)
    }
    func removeBlurEffect(){
        DispatchQueue.main.sync {
            self.blurVisualEffect?.removeFromSuperview()
            self.activityIndicator?.removeFromSuperview()
        }
        
    }
}

