//
//  SlidingViewController.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit
import NavigationDrawer
class SlidingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK: Variables
    var interactor:Interactor? = nil
    var img:[String] = ["\(String(describing: UIImage(named: "footprint")))"]
    var arrMenuItems:[String] = []
   // var arrMenuItems:[String] = ["Map View","List View","Create Posts","Saved Posts","Settings","Log-Out"]
    var arrImages:[String] = ["world-wide-web","menu (2)","add","bookmark","setting","power-off"]
    var myIndex = -1
    //MARK: Outlets
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contentView.addSubview(tblView)
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            let mapView = "Map View".localizableString(loc: "ar")
            let listView = "List View".localizableString(loc: "ar")
            let create = "Create Posts".localizableString(loc: "ar")
            let save = "Saved Posts".localizableString(loc: "ar")
            let settings = "Settings".localizableString(loc: "ar")
            let logOut = "Log-Out".localizableString(loc: "ar")
            arrMenuItems.append(mapView)
            arrMenuItems.append(listView)
            arrMenuItems.append(create)
            arrMenuItems.append(save)
            arrMenuItems.append(settings)
            arrMenuItems.append(logOut)
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            let mapView = "Map View".localizableString(loc: "en")
            let listView = "List View".localizableString(loc: "en")
            let create = "Create Posts".localizableString(loc: "en")
            let save = "Saved Posts".localizableString(loc: "en")
            let settings = "Settings".localizableString(loc: "en")
            let logOut = "Log-Out".localizableString(loc: "en")
            arrMenuItems.append(mapView)
            arrMenuItems.append(listView)
            arrMenuItems.append(create)
            arrMenuItems.append(save)
            arrMenuItems.append(settings)
            arrMenuItems.append(logOut)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Handle Gesture
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            let translation = sender.translation(in: view)
            
            let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
            
            MenuHelper.mapGestureStateToInteractor(
                gestureState: sender.state,
                progress: progress,
                interactor: interactor){
                    self.dismiss(animated: true, completion: nil)
            }
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            let translation = sender.translation(in: view)
            
            let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)
            
            MenuHelper.mapGestureStateToInteractor(
                gestureState: sender.state,
                progress: progress,
                interactor: interactor){
                    self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK: Button-Actions
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    //MARK: TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return img.count
        }else{
            return arrImages.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0{
            let cell = tblView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)as! IconImageTableViewCell
            let image = UIImage(named: "footprint")
            print(image as Any)
            cell.iconImage!.image = image!
            print(cell.iconImage.image as Any)
            return cell
        }else if indexPath.section == 1{
            let cell = tblView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)as? SlidingItemsTableViewCell
            let item = arrMenuItems[indexPath.row]
            print(item)
            cell?.lblItems?.text = item
            cell?.imgView.image = UIImage(named: "\(arrImages[indexPath.row])")
            
            return cell!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            print("Photo Touched")
        }else{
            if indexPath.row == 0{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(newVC)
                print("mapView")
            }else if indexPath.row == 1{
                print("listView")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController")as! ListViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }else if indexPath.row == 2{
                print("CreatePosts")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostsViewController")as! CreatePostsViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }else if indexPath.row == 3{
                print("Saved posts")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SavedPostsViewController")as! SavedPostsViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }else if indexPath.row == 4{
                print("Settings")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")as! SettingsViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }else{
                let storyboaard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboaard.instantiateViewController(withIdentifier: "MainNavigationController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                
            }
        }
    }
}
