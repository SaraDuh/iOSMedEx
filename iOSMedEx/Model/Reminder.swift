//
//  Reminder.swift
//  iOSMedEx
//
//  Created by Deema on 17/06/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
import UIKit

class Reminder: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {

    }
    
    
    // Properties
    var notification: UILocalNotification
    var name: String
    var time: NSDate
    
    // Archive Paths for Persistent Data
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    // enum for property types
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    // Initializer
    init(name: String, time: NSDate, notification: UILocalNotification) {
        // set properties
        self.name = name
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    // Destructor
    deinit {
        // cancel notification
        UIApplication.shared.cancelLocalNotification(self.notification)
    }
    
    // NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(notification, forKey: PropertyKey.notificationKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! NSDate
        
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UILocalNotification
        
        // Must call designated initializer.
        self.init(name: name, time: time, notification: notification)
    }
}
