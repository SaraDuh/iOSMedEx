//
//  Reminders.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 07/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Reminders {
 
    var title: String?
    var time: String?
    var id: String?
    
    init(title: String?, time: String?, id: String?){
        self.title = title
        self.time = time
        self.id = id
        
    }
}
