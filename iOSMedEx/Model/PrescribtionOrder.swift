//
//  PrescribtionOrder.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 29/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//


import Foundation
class PrescribtionOrder {
    var OrderRX: String?
    var medID : String?
    var medName: String?
    var medPrice: String?
    var OrderStatus: String?
    
    
    init (OrderRX:String?,medID: String?, medName:String?, medPrice: String?, OrderStatus:String?){
        self.OrderRX = OrderRX;
        self.medID = medID;
        self.medName = medName;
        self.medPrice = medPrice;
        self.OrderStatus = OrderStatus;
        
    }
    /*
     var prescriptionDate: String?
     var status: String?
     
     init (prescriptionDate:String?, status:String?){
     self.prescriptionDate = prescriptionDate;
     self.status = status;
     }*/
}

