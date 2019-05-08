//
//  CartTableViewCell.swift
//  iOSMedEx
//
//  Created by Deema on 01/06/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var price: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
