//
//  myPrescriptionsTableViewCell.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class myPrescriptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var prescriptionNo: UILabel!
    
    @IBOutlet weak var prescriptionDate: UILabel!
    
    @IBOutlet weak var physicionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
