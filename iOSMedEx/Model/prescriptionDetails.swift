//
//  prescriptionDetails.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 17/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation

class prescriptionDetails {
    var key: String?
    var name: String?
    var dose: String?
    var frequency: String?
    var quantity: String?
    var nextRefillDate: String?
    var relatedDetails: String?
    
    
    init(key: String?, name: String?, dose: String?, frequency: String?, quantity: String?, nextRefillDate: String?, relatedDetails: String?){
        self.key = key
        self.name = name
        self.dose = dose
        self.frequency = frequency
        self.quantity = quantity
        self.nextRefillDate = nextRefillDate
        self.relatedDetails = relatedDetails
    }
}
