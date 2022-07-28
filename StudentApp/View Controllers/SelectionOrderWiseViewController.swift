//
//  SelectionOrderWiseViewController.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit
enum Selection{
    case aZ
    case zA
    case idA
    case idD
    case marksA
    case marksD
}


protocol DataPass{
    func dataPassing(optionChoosen: Selection)
}
class SelectionOrderWiseViewController: UIViewController {
    //MARK: Variables
    var delegate: DataPass!
    
    var image = UIImage()
    var selectedFilter = Selection.idA
    let savedFilter = UserDefaults.standard.string(forKey: "selectedFilter")
    //MARK: Outlets
    
    @IBOutlet weak var btnOutletaZ: UIButton!
    @IBOutlet weak var btnOutletzA: UIButton!
    @IBOutlet weak var btnOutletidA: UIButton!
    @IBOutlet weak var btnOutletidD: UIButton!
    @IBOutlet weak var btnOutletmarksA: UIButton!
    @IBOutlet weak var btnOutletMarksD: UIButton!
    
    
    @IBOutlet weak var imgViewAZ: UIImageView!
    @IBOutlet weak var imgViewZA: UIImageView!
    @IBOutlet weak var imgViewidA: UIImageView!
    @IBOutlet weak var imgViewidD: UIImageView!
    @IBOutlet weak var imgViewmarksA: UIImageView!
    @IBOutlet weak var imgViewMarksD: UIImageView!
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if savedFilter == "aZ"{
            imgViewAZ.image = UIImage(named: "check")
        }else if savedFilter == "zA"{
            imgViewZA.image = UIImage(named: "check")
        }else if savedFilter == "idA"{
            imgViewidA.image = UIImage(named: "check")
        }else if savedFilter == "idD"{
            imgViewidD.image = UIImage(named: "check")
        }else if savedFilter == "marksA"{
            imgViewmarksA.image = UIImage(named: "check")
        }else if savedFilter == "marksD"{
            imgViewMarksD.image = UIImage(named: "check")
        }
    }
  
    //MARK: Button Actions
    
    @IBAction func btnActionSortAZ(_ sender: UIButton) {
        btnOutletaZ.isSelected = !btnOutletaZ.isSelected
        if btnOutletaZ.isSelected == true{
            imgViewAZ.image = UIImage(named: "check")
            btnOutletzA.isSelected = false
            btnOutletidA.isSelected = false
            btnOutletidD.isSelected = false
            btnOutletmarksA.isSelected = false
            btnOutletMarksD.isSelected = false
            imgViewZA.image = UIImage(named: "unCheck")
            imgViewidA.image = UIImage(named: "unCheck")
            imgViewidD.image = UIImage(named: "unCheck")
            imgViewmarksA.image = UIImage(named: "unCheck")
            imgViewMarksD.image = UIImage(named: "unCheck")
        }
        delegate.dataPassing(optionChoosen: .aZ)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActionSortZA(_ sender: UIButton) {
        btnOutletzA.isSelected = !btnOutletzA.isSelected
        if btnOutletzA.isSelected == true{
            btnOutletaZ.isSelected = false
            btnOutletidA.isSelected = false
            btnOutletidD.isSelected = false
            btnOutletmarksA.isSelected = false
            btnOutletMarksD.isSelected = false
            imgViewAZ.image = UIImage(named: "unCheck")
            imgViewZA.image = UIImage(named: "check")
            imgViewidA.image = UIImage(named: "unCheck")
            imgViewidD.image = UIImage(named: "unCheck")
            imgViewmarksA.image = UIImage(named: "unCheck")
            imgViewMarksD.image = UIImage(named: "unCheck")
        }
        delegate.dataPassing(optionChoosen: .zA)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionidAscending(_ sender: UIButton) {
        btnOutletidA.isSelected = !btnOutletidA.isSelected
        if btnOutletidA.isSelected == true{
            btnOutletaZ.isSelected = false
            btnOutletzA.isSelected = false
            btnOutletidD.isSelected = false
            btnOutletmarksA.isSelected = false
            btnOutletMarksD.isSelected = false
            imgViewAZ.image = UIImage(named: "unCheck")
            imgViewZA.image = UIImage(named: "unCheck")
            imgViewidA.image = UIImage(named: "check")
            imgViewidD.image = UIImage(named: "unCheck")
            imgViewmarksA.image = UIImage(named: "unCheck")
            imgViewMarksD.image = UIImage(named: "unCheck")
        }
        delegate.dataPassing(optionChoosen: .idA)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionidDescending(_ sender: UIButton) {
        btnOutletidD.isSelected = !btnOutletidD.isSelected
        if btnOutletidD.isSelected == true{
            btnOutletaZ.isSelected = false
            btnOutletzA.isSelected = false
            btnOutletidA.isSelected = false
            btnOutletmarksA.isSelected = false
            btnOutletMarksD.isSelected = false
            imgViewAZ.image = UIImage(named: "unCheck")
            imgViewZA.image = UIImage(named: "unCheck")
            imgViewidA.image = UIImage(named: "unCheck")
            imgViewidD.image = UIImage(named: "check")
            imgViewmarksA.image = UIImage(named: "unCheck")
            imgViewMarksD.image = UIImage(named: "unCheck")
        }
        delegate.dataPassing(optionChoosen: .idD)
            self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionMarksA(_ sender: UIButton) {
        btnOutletmarksA.isSelected = !btnOutletmarksA.isSelected
        if btnOutletmarksA.isSelected == true{
            btnOutletaZ.isSelected = false
            btnOutletzA.isSelected = false
            btnOutletidA.isSelected = false
            btnOutletidD.isSelected = false
            btnOutletMarksD.isSelected = false
            imgViewAZ.image = UIImage(named: "unCheck")
            imgViewZA.image = UIImage(named: "unCheck")
            imgViewidA.image = UIImage(named: "unCheck")
            imgViewidD.image = UIImage(named: "unCheck")
            imgViewmarksA.image = UIImage(named: "check")
            imgViewMarksD.image = UIImage(named: "unCheck")
        }
        delegate.dataPassing(optionChoosen: .marksA)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActionMarksD(_ sender: UIButton) {
        btnOutletMarksD.isSelected = !btnOutletMarksD.isSelected
        if btnOutletMarksD.isSelected == true{
            btnOutletaZ.isSelected = false
            btnOutletzA.isSelected = false
            btnOutletidA.isSelected = false
            btnOutletidD.isSelected = false
            btnOutletidA.isSelected = false
            imgViewAZ.image = UIImage(named: "unCheck")
            imgViewZA.image = UIImage(named: "unCheck")
            imgViewidA.image = UIImage(named: "unCheck")
            imgViewidD.image = UIImage(named: "unCheck")
            imgViewmarksA.image = UIImage(named: "unCheck")
            imgViewMarksD.image = UIImage(named: "check")
        }
        delegate.dataPassing(optionChoosen: .marksD)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
   //MARK: Extensions
   
