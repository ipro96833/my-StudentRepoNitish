//
//  GetDataOnlineViewController.swift
//  LoginDataBase
//
//  Created by mac on 04/08/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoKit
import SDWebImage
import CoreData
class GetDataOnlineViewController: UIViewController {
    //MARK: Variables
    var arrDataDict = [JSONHelper]()
    var infoP = [String:String]()
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    var indexing = 0
    var arrData = [JSONHelper]()
    var dict = [String:Any]()
    var context = CoreDataHelper.sharedInstance.context
    //MARK: Outlets
    
    
    @IBOutlet weak var btnOutletSavedData: UIButton!
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AF.request("https://app.famousfootprints.com/api/locations", method: .post, parameters: "", encoder: JSONParameterEncoder.default).response{response in
            if response.data != nil{
            let jsonData = JSON(response.data!)
            let info = jsonData["locations"]
                for index in 0..<info.count{
                    if info.count > 30{
                        let data1 = info[index]["img"]
                        let image = data1[0]["1"].string ?? "nil"
                        print(image)
                        let location_address = info[index]["location_address"].string ?? ""
                        let dict = ["uid":info[index]["uid"].string ?? "nil", "location_address":info[index]["location_address"].string ?? "nil","img":image]
                        let data = JSONHelper(dict: dict)
                        self.arrDataDict.append(data)
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
                        var results:[Locations] = []
                        do{
                            results = try self.context.fetch(fetchRequest) as! [Locations]
                        }catch{
                            let error = error as NSError
                            print(error)
                        }
                        if results.count > 0{
                            for x in results{
                                if x.location_address == location_address{
                                    print("already exists")
                                    self.context.delete(x)
                                }
                            }
                        }else{
                            CoreDataHelper.sharedInstance.saveData(object: dict)
                        }
                       
                        if index == 30{
                            break
                        }
                    }else{
                        print("nothing")
                    }
                }
                print(self.arrDataDict)
                self.tblView.reloadData()
            }else{
                print("Error")
            }
        }
        
    }
    
    //MARK: Button Actions
    
    
    
    //MARK: Functions
}
//MARK: Extensions
extension GetDataOnlineViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDataDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineCell", for: indexPath) as! GetDataOnlineTableViewCell
        let idData = arrDataDict.map({ (id: JSONHelper)  in
            id.uid
        })
        cell.lblId.text = idData[indexPath.row]
        let locationData = arrDataDict.map({ (name: JSONHelper)  in
            name.location_address
        })
        cell.lblAddress.text = locationData[indexPath.row]
        let imgData = arrDataDict.map({ (img: JSONHelper)  in
            img.img
        })
        
        cell.img.sd_imageIndicator = true as? SDWebImageIndicator
        cell.img.sd_setImage(with: URL(string: imgData[indexPath.row]), placeholderImage: UIImage(named: "image"), options: .handleCookies, completed: nil)

        return cell
    }
    
}
