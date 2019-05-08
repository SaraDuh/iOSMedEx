//
//  DriverProfileViewController.swift
//  iOSMedEx
//
//  Created by Deema on 23/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class DriverProfileViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverPhone: UILabel!
    @IBOutlet weak var driverEmail: UILabel!
    @IBOutlet weak var driverArea: UILabel!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        editProfile.layer.cornerRadius = 25
        editProfile.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("users");
        
         ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userObject = snapshot.value as? [String: AnyObject]
            let userName  = userObject?["Name"]
            let userEmail  = userObject?["Email"]
            let userPhone = userObject?["PhoneNo"]
            let userArea = userObject?["DeliveryArea"]
            //appending it to list
            self.driverName.text = userName as? String
            self.driverEmail.text = userEmail as? String
            self.driverPhone.text = userPhone as? String
            self.driverArea.text = userArea as? String
            //initials icon
            let initials = userName?.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            self.initialsLabel.text = initials
            
            })
    }
    

}
