//
//  myRefillsTableViewCell.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class myRefillsTableViewCell: UITableViewCell {

    @IBOutlet weak var refillNo: UILabel!
    @IBOutlet weak var refillDate: UILabel!
    @IBOutlet weak var physicionName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dose: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var relatedDetails: UILabel!
    @IBOutlet weak var orderRefill: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
