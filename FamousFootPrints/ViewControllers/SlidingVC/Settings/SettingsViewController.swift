//
//  SettingsViewController.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit
import NavigationDrawer
class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: Variables
    let interactor = Interactor()
    var arrTitleSettings:[String] = []
    var arrTitleImages = ["user","bell","share","language","terms","shield"]
    
    //MARK: Outlets
    @IBOutlet weak var bar: UINavigationItem!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var settingsNavigationBar: UINavigationBar!
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "footprints"))
        settingsNavigationBar.topItem?.titleView = imageView
        settingsNavigationBar.layer.masksToBounds = true
        settingsNavigationBar.shadowImage = UIImage()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblView.reloadData()
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageChange(str: "ar")
                let Profile = "Profile".localizableString(loc: "ar")
                let Notifications = "Notifications".localizableString(loc: "ar")
                let ShareApp = "Share App".localizableString(loc: "ar")
                let language = "SelectLanguage".localizableString(loc: "ar")
                let tC = "Terms and Conditions".localizableString(loc: "ar")
                let pP = "Privacy Policy".localizableString(loc: "ar")
            arrTitleSettings.append(Profile)
            arrTitleSettings.append(Notifications)
            arrTitleSettings.append(ShareApp)
            arrTitleSettings.append(language)
            arrTitleSettings.append(tC)
            arrTitleSettings.append(pP)
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageChange(str: "en")
            let Profile = "Profile".localizableString(loc: "en")
            let Notifications = "Notifications".localizableString(loc: "en")
            let ShareApp = "Share App".localizableString(loc: "en")
            let language = "SelectLanguage".localizableString(loc: "en")
            let tC = "Terms and Conditions".localizableString(loc: "en")
            let pP = "Privacy Policy".localizableString(loc: "en")
               
            arrTitleSettings.append(Profile)
            arrTitleSettings.append(Notifications)
            arrTitleSettings.append(ShareApp)
            arrTitleSettings.append(language)
            arrTitleSettings.append(tC)
            arrTitleSettings.append(pP)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
            
            #warning("From iOS 13, you need to make presentationStyle to fullScreen.")
            destinationViewController.modalPresentationStyle = .fullScreen
//            destinationViewController.mainVC = self
        }
    }
//MARK: Button-Actions
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)

        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)

        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "settingsshowSlidingMenu", sender: nil)
        }
    }
    func languageChange(str: String){
        self.bar.title = "Settings".localizableString(loc: str)
    }
    //MARK: TableView-Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitleImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell",for: indexPath)as? SettingsTableViewCell
        cell?.lblSettingsTitle?.text = arrTitleSettings[indexPath.row]
        cell?.imgView.image = UIImage(named: "\(arrTitleImages[indexPath.row])")
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
            self.present(newVC, animated: true, completion: nil)
        }else if indexPath.row == 1{
            
        }else if indexPath.row == 2{
            
        }else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewViewController")as! NewViewController
            self.present(vc, animated: true, completion: nil)
            
            
        }else if indexPath.row == 4{
            
        }else if indexPath.row == 5{
            
        }
    }
}
extension SettingsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            let animator = PresentMenuAnimator(direction: .Right)
            animator.shadowOpacity = 0.1
            return animator

        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            let animator = PresentMenuAnimator(direction: .Left)
            animator.shadowOpacity = 0.1
            return animator

        }
        let animator = PresentMenuAnimator(direction: .Left)
        animator.shadowOpacity = 0.1
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

