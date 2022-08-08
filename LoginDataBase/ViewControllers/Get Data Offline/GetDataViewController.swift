//
//  GetDataViewController.swift
//  LoginDataBase
//
//  Created by mac on 04/08/22.
//

import UIKit

class GetDataViewController: UIViewController {

    //MARK: Variables
    var locations = [Locations]()
    var id:String = ""
    var email:String = ""
    var token:String = ""
    var number:String = ""
    var uid:String = ""
    
    //MARK: Outlets
    
    
    @IBOutlet weak var btnOutletGetDataOnline: UIButton!
    @IBOutlet weak var btnOutletSavedData: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblUid: UILabel!
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblId.text = id
        lblEmail.text = email
        lblToken.text = token
        lblNumber.text = number
        lblUid.text = uid
        locations = CoreDataHelper.sharedInstance.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
    }

    //MARK: Button Actions
    
    
    
    
    @IBAction func btnActionSavedData(_ sender: UIButton) {
    }
    
    @IBAction func btnActionGetData(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetDataOnlineViewController")as! GetDataOnlineViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Functions
   
    
}
//MARK: Extensions

extension GetDataViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "OfflineCell")as! GetDataOfflineTableViewCell
        cell.lbluid.text = locations[indexPath.row].uid
        cell.lblAddress.text = locations[indexPath.row].location_address
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            locations = CoreDataHelper.sharedInstance.deleteData(dataIndex: indexPath.row)
            self.tblView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

