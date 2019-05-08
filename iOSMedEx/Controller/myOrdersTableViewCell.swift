//
//  myOrdersTableViewCell.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class myOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderRx: UILabel!
    @IBOutlet weak var medName: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var addToCart: UIButton!
    
        override func awakeFromNib() {        super.awakeFromNib()        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
