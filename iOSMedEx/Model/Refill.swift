//
//  Refill.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Refill {
    
    var refillNo: String?
    var medID: String?
    var date: String?
    var physicionName: String?
    var name: String?
    var dose: String?
    var frequency: String?
    var quantity: String?
    var relatedDetails: String?
    
    init(refillNo: String?, medID: String?, date: String?, physicionName: String?, name: String?, dose: String?, frequency: String?, quantity: String?, relatedDetails: String?){
        self.refillNo = refillNo
        self.medID = medID
        self.date = date
        self.physicionName = physicionName
        self.name = name
        self.dose = dose
        self.frequency = frequency
        self.quantity = quantity
        self.relatedDetails = relatedDetails
    }
}
