//
//  PatientProfileViewController.swift
//  iOSMedEx
//
//  Created by Deema on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

//extension String
//{
//    public func getAcronyms(separator: String = "") -> String
//    {
//        let acronyms = self.components(separatedBy: " ").map({ String($0.characters.first!) }).joined(separator: separator);
//        return acronyms;
//    }
//}

class PatientProfileViewController: UIViewController {
    
    var ref: DatabaseReference!
    var adrref: DatabaseReference!
    
    @IBOutlet weak var PName: UILabel!
    
    @IBOutlet weak var PAge: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var mrn: UILabel!
    @IBOutlet weak var medHistory: UILabel!

    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var strtName: UILabel!
    @IBOutlet weak var neighborhood: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var pc: UILabel!
    @IBOutlet weak var ac: UILabel!
    
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var initialsLabel: UILabel!
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            editProfile.layer.cornerRadius = 30
            editProfile.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("users");
        adrref = Database.database().reference().child("users");
            
        ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.adrref.child(userID!).child("Address").observeSingleEvent(of: .value, with: { (snapshot1) in
            // Get user value
            let userObject = snapshot.value as? [String: AnyObject]
            let adrObject = snapshot1.value as? [String: AnyObject]
            let userName  = userObject?["Name"]
            let userAge  = userObject?["Age"]
            let userGender = userObject?["Gender"]
            let userMRN = userObject?["MRN"]
            let userMedHistory = userObject?["MedicalHistory"]
            let userPhone = userObject?["PhoneNo"]
            let userAddress = adrObject?["BuildingNo"]
            let uStreet = adrObject?["Street Name"]
            let uNieghborhood = adrObject?["Neighborhood"]
            let uCity = adrObject?["City"]
            let uPC = adrObject?["Postal Code"]
            let uAN = adrObject?["AdditionalNo"]
            
            //appending it to list
            self.PName.text = userName as? String
            self.PAge.text = (userAge as? String)
            self.gender.text = (userGender as! String)
            self.mrn.text = (userMRN as? String)
            self.medHistory.text = (userMedHistory as? String)
            self.phoneNo.text = (userPhone as? String)
            self.address.text = (userAddress as? String)
            self.strtName.text = (uStreet as? String)
            self.neighborhood.text = (uNieghborhood as? String)
            self.city.text = (uCity as? String)
            self.pc.text = (uPC as? String)
            self.ac.text = (uAN as? String)
            
            let initials = userName?.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            self.initialsLabel.text = initials
        })
            })
    }

    }
    
    

