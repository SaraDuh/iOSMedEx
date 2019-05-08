//
//  medicinesTableViewCell.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 17/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class medicinesTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var dose: UILabel!
    
    @IBOutlet weak var frequency: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var nextRefillDate: UILabel!
    
    @IBOutlet weak var relatedDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
