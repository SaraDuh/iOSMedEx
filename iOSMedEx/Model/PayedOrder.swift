//
//  PayedOrder.swift
//  iOSMedEx
//
//  Created by Deema on 30/06/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class PayedOrder {
    //RX
    var AdditionalNo: String?
    var AssignedDriver: String?
    var BuildingNo: String?
    var City: String?
    var MRN: String?
    var Neighborhood: String?
    var OrderDate: String?
    var PostalCode: String?
    var StreetName: String?
    var phoneNo: String?
    var id : String?
 
    
    
    
    init(AdditionalNo: String?, AssignedDriver: String?, BuildingNo: String?, City: String?, MRN: String?, Neighborhood: String?, OrderDate: String?, PostalCode: String?, StreetName: String?, phoneNo: String?, id: String?){
        self.AdditionalNo = AdditionalNo
        self.AssignedDriver = AssignedDriver
        self.BuildingNo = BuildingNo
        self.City = City
        self.MRN = MRN
        self.Neighborhood = Neighborhood
        self.OrderDate = OrderDate
        self.PostalCode = PostalCode
        self.StreetName = StreetName
        self.phoneNo = phoneNo
        self.id = id
        
    }
}
