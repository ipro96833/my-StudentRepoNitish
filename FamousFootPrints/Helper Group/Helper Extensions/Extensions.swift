//
//  Extensions.swift
//  FamousFootPrints
//
//  Created by mac on 05/07/22.
//

import Foundation
import UIKit



extension String{
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path ?? "Something")
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension UIView {
    func add(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UITextField {
  open override func awakeFromNib() {
    super.awakeFromNib()
      if UserDefaults.standard.string(forKey: "languageCode") == "ar" {
        if textAlignment == .natural {
            self.textAlignment = .right
        }else{
            self.textAlignment = .natural
        }
    }
}
}
extension UIViewController{
    func loader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let screen = UIScreen.main.bounds.size.width/2

        let active = UIActivityIndicatorView(frame: CGRect(x: screen/2, y: 5, width: 50, height: 40))
       // let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let indicator = active
        indicator.hidesWhenStopped = true
        alert.view?.addSubview(indicator)
        indicator.startAnimating()
        present(alert, animated: true, completion: nil)
        return alert
    }
    func stoploader(loader: UIAlertController){
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
