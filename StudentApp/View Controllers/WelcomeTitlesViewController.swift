//
//  WelcomeTitlesViewController.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit

class WelcomeTitlesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
   
       //MARK: Variables
    var arrTitlesForChoose:[String] = ["Add Student","Student's List","Settings"]
    var arrTitleImages:[String] = ["add","list","settings"]
    
    //MARK: Outlets
    
    @IBOutlet weak var collectionViewTitleSelection: UICollectionView!
    
    
    
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    //MARK: Button Actions
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Functions
    //MARK: CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath)as! TitlesCollectionViewCell
        cell.imgView.image = UIImage(named: arrTitleImages[indexPath.row])
        cell.lblTitles.text = arrTitlesForChoose[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StudentRegistrationViewController")as! StudentRegistrationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StudentListViewController")as! StudentListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            
        }
    }
    
    
}
//MARK: Extensions
extension WelcomeTitlesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
           let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
           return CGSize(width: size, height: size)
       }
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let collectionWidth = collectionView.bounds.width
//        return CGSize(width: collectionWidth/2, height: collectionWidth/2)
//        }
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 0
//        }
    
}
