//
//  Cart.swift
//  iOSMedEx
//
//  Created by Deema on 01/06/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Cart {
    //RX
    var orderNo: String?
    var medName: String?
    var price: String?
    var medID: String?
    
    init(orderNo: String?, medName: String?, price: String?, medID: String?){
        self.orderNo = orderNo
        self.medName = medName
        self.price = price
        self.medID = medID
    }
}
