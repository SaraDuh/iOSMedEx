//
//  Prescription.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Prescription {
    
    var Rx: String?
    var date: String?
    var physicionName: String?
    
    init(Rx: String, date: String?, physicionName: String?){
        self.Rx = Rx
        self.date = date
        self.physicionName = physicionName
    }
}
