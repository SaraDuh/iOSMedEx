//
//  PatientUpdateProfileViewController.swift
//  iOSMedEx
//
//  Created by Deema on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class PatientUpdateProfileViewController: UIViewController, UITextFieldDelegate  {

    var ref: DatabaseReference!
     var adrref: DatabaseReference!
    var mrnPhoneRef:  DatabaseReference!
    var refU:  DatabaseReference!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var buildingNo: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var neighborhood: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var addNo: UITextField!
    
    
    @IBOutlet weak var createdLable: UILabel!
    
    @IBOutlet weak var cancleB: UIButton!
    @IBOutlet weak var doneB: UIButton!
    
//    @IBAction func done(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        cancleB.layer.cornerRadius = 30
        cancleB.layer.masksToBounds = true
        doneB.layer.cornerRadius = 30
        doneB.layer.masksToBounds = true
        createdLable.isHidden = true
        
        name.delegate = self
        name.setBottomBorder();
        
        phoneNo.delegate = self
        phoneNo.setBottomBorder();
        
        buildingNo.delegate = self
        buildingNo.setBottomBorder();
        
        street.delegate = self
        street.setBottomBorder();
        
        neighborhood.delegate = self
        neighborhood.setBottomBorder();
        
        city.delegate = self
        city.setBottomBorder();
        
        postalCode.delegate = self
        postalCode.setBottomBorder();
        
        addNo.delegate = self
        addNo.setBottomBorder();
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("users");
        adrref = Database.database().reference().child("users");
        
        ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.adrref.child(userID!).child("Address").observeSingleEvent(of: .value, with: { (snapshot1) in
            
            // Get user value
            let userObject = snapshot.value as? [String: AnyObject]
            let adrObject = snapshot1.value as? [String: AnyObject]
            let userName  = userObject?["Name"]
            let userPhone  = userObject?["PhoneNo"]
                
            let userAddress  = adrObject?["BuildingNo"]
            let uStreet = adrObject?["Street Name"]
            let uNieghborhood = adrObject?["Neighborhood"]
            let uCity = adrObject?["City"]
            let uPC = adrObject?["Postal Code"]
            let uAN = adrObject?["AdditionalNo"]
            
            //appending it to list
            self.name.text = userName as? String
            self.phoneNo.text = (userPhone as! String)
            self.buildingNo.text = (userAddress as! String)
            self.street.text = (uStreet as! String)
            self.neighborhood.text = (uNieghborhood as! String)
            self.city.text = (uCity as! String)
            self.postalCode.text = (uPC as! String)
            self.addNo.text = (uAN as! String)
            // Do any additional setup after loading the view.
        })
             })
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        let newName = self.name.text
        let newPhone = self.phoneNo.text
        let newAddress = self.buildingNo.text
        let newStreet = self.street.text
        let newNH = self.neighborhood.text
        let newCity = self.city.text
        let newPC = self.postalCode.text
        let newANo = self.addNo.text
        
        if newName != nil && newPhone != nil && newAddress != nil {
            if newPhone!.count == 13 {
                let phoneString = newPhone!
                let indexEndOfText = phoneString.index(phoneString.endIndex, offsetBy: -9)
                let substring2 = phoneString[..<indexEndOfText]
                if substring2 == "+966" {
                    let newProfileValues = ["Name": newName, "PhoneNo":newPhone]
                    let newAddressValues = ["BuildingNo": newAddress, "Street Name":newStreet, "Neighborhood":newNH, "City":newCity, "Postal Code":newPC, "AdditionalNo":newANo]

                    self.ref.child(userID!).updateChildValues(newProfileValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        print("CHANGED")
                        print("Profile Updated Successfully")
                       // self.createdLable.text = "Profile Updated Successfully!"
                       // self.createdLable.isHidden = false
                      //  DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                          //  self.createdLable.isHidden = true
                        //}
                    })
                    self.adrref.child(userID!).child("Address").updateChildValues(newAddressValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        print("CHANGED")
                        print("Profile Updated Successfully")
                        self.createdLable.text = "Profile Updated Successfully!"
                        self.createdLable.isHidden = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.createdLable.isHidden = true
                        }
                    })
                    //joj1 test1
                    refU = Database.database().reference().child("users");
                    refU.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user MRN value
                        let userObject = snapshot.value as? [String: AnyObject]
                        let userMRN = userObject?["MRN"]
                        let uMRN = (userMRN as! String)
                        self.mrnPhoneRef = Database.database().reference().child("MRNs & PhoneNos");
                        self.mrnPhoneRef.observe(DataEventType.value, with: {(snapshot) in
                            //if the reference have some values
                            if snapshot.childrenCount>0{
                                //iterating through all the values
                                for mrns in snapshot.children.allObjects as! [DataSnapshot] {
                                    //getting values
                                    let mrnPhonesObject = mrns.value as? [String: AnyObject]
                                    let mrn = mrnPhonesObject?["MRN"]
                                    if (mrn!.isEqual(uMRN)){
                                        
                                        let newProfileValues1 = ["PhoneNo":newPhone]
                                        self.mrnPhoneRef.child(uMRN).updateChildValues(newProfileValues1 as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                                            if error != nil{
                                                print(error!)
                                                return
                                            }
                                            print("PHONE CHANGED")
                                            print("Phone Updated Successfully")
                                        })
                                        
                                    }
                                }
                            }
                        })
                    })
                    //joj1 test1
                } //if substring == "+966"
                else { print("wrong phone format")
                    self.createdLable.text = "Profile Not Updated!, Phone number should start with [+966]"
                    self.createdLable.isHidden = false
                }
            } //if newPhone!.count == 13
            else{
                print("phone no is less than 13")
                self.createdLable.text = "Profile Not Updated!, Phone number should contain 9 digits"
                self.createdLable.isHidden = false
            }
        }
        

    }
    
    @IBAction func cancle(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
}
