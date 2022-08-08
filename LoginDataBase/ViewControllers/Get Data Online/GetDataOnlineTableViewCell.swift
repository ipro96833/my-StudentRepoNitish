//
//  GetDataOnlineTableViewCell.swift
//  LoginDataBase
//
//  Created by mac on 04/08/22.
//

import UIKit

class GetDataOnlineTableViewCell: UITableViewCell {

    @IBOutlet weak var lblId: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
