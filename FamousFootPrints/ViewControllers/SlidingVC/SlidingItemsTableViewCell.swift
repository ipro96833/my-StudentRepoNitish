//
//  SlidingItemsTableViewCell.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit

class SlidingItemsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var lblItems: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
