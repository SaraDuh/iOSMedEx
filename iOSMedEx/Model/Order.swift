//
//  PatientOrder.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Order {
    var OrderNo: String?
    var OrderDate: String?
    var OrderStatus: String?
    
    init (OrderNo:String?, OrderDate:String?, OrderStatus:String?){
        self.OrderNo = OrderNo;
        self.OrderDate = OrderDate;
        self.OrderStatus = OrderStatus;
    }

}
