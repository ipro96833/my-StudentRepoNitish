//
//  StudentListTableViewCell.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit

class StudentListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblMarks: UILabel!
    
//    var student: StudentInformation!{
//        didSet{
//            lblName.text = "Name: \(String(describing: student.name!))"
//            lblId.text = "ID: \(String(describing: student.id!))"
//            lblMarks.text = "Total Marks: \(String(describing: student.totalMarks!))"
//            let image = student.img
//            if image != nil{
//            let studentImage = UIImage(data: image!)
//            imgView.image = studentImage
//            }else{
//                imgView.image = UIImage(named: "addStudent")
//            }
//        }
//   }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
