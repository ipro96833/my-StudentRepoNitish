//
//  NewViewController.swift
//  StudentApp
//
//  Created by mac on 25/07/22.
//

import UIKit
enum CategorySelection{
    case AZ
    case ZA
    case Same
}
protocol animalPass{
    func passingData(option:CategorySelection)
}
class NewViewController: UIViewController {
    var selectedFilter = CategorySelection.AZ
    var delegate: animalPass!
    //MARK: Outlets
    
    @IBOutlet weak var btnOutletAZ: UIButton!
    @IBOutlet weak var btnOutletZA: UIButton!
    @IBOutlet weak var btnOutletSame: UIButton!
    @IBOutlet weak var imgViewAZ: UIImageView!
    @IBOutlet weak var imgViewZA: UIImageView!
    @IBOutlet weak var imgViewSame: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    //MARK: Button Actions
    
    @IBAction func btnActionAZ(_ sender: UIButton) {
        delegate.passingData(option: .AZ)
        self.dismiss(animated: true)
    }
    
  
    @IBAction func btnActionZA(_ sender: UIButton) {
        delegate.passingData(option: .ZA)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnActionSame(_ sender: UIButton) {
        delegate.passingData(option: .Same)
        self.dismiss(animated: true)
    }
    
}
