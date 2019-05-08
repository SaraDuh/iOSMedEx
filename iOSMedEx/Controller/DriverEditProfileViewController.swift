//
//  DriverEditProfileViewController.swift
//  iOSMedEx
//
//  Created by Deema on 23/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase


class DriverEditProfileViewController: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var dName: UITextField!
    @IBOutlet weak var dPhone: UITextField!
    @IBOutlet weak var dEmail: UITextField!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var calcleButton: UIButton!
    
    @IBAction func done(_ sender: Any) {
         //self.dismiss(animated: true, completion: nil)
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.hideKeyboard()
            
        calcleButton.layer.cornerRadius = 30
        calcleButton.layer.masksToBounds = true
        updateButton.layer.cornerRadius = 30
        updateButton.layer.masksToBounds = true
        createdLabel.isHidden = true
        
        dName.delegate = self as? UITextFieldDelegate
        dName.setBottomBorder();
        
        dPhone.delegate = self as? UITextFieldDelegate
        dPhone.setBottomBorder();
        
        dEmail.delegate = self as? UITextFieldDelegate
        dEmail.setBottomBorder();
        // Do any additional setup after loading the view.
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("users");
        
         ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = snapshot.value as? [String: AnyObject]
            let userName  = userObject?["Name"]
            let userPhone  = userObject?["PhoneNo"]
            let userEmail  = userObject?["Email"]
            
            self.dName.text = userName as? String
            self.dPhone.text = (userPhone as! String)
            self.dEmail.text = (userEmail as! String)
            })
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        let newName = self.dName.text
        let newPhone = self.dPhone.text
        let newEmail = self.dEmail.text
        
         if newName != nil && newPhone != nil && newEmail != nil {
            if Auth.auth().currentUser != nil{
                Auth.auth().currentUser?.updateEmail(to: newEmail!) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        self.createdLabel.text = "Can't be Updated!"
                        self.createdLabel.isHidden = false
                    } else {
             if newPhone!.count == 12 {
                let phoneString = newPhone!
                let indexEndOfText = phoneString.index(phoneString.endIndex, offsetBy: -9)
                let substring2 = phoneString[..<indexEndOfText]
                if substring2 == "966" {
                     let newProfileValues = ["Name": newName, "PhoneNo":newPhone, "Email":newEmail]
                    self.ref.child(userID!).updateChildValues(newProfileValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        print("CHANGED")
                        print("Profile Updated Successfully")
                        self.createdLabel.text = "Profile Updated Successfully!"
                        self.createdLabel.isHidden = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.createdLabel.isHidden = true
                        }
                    })
                }//if substring2 == "+966"
                else { print("wrong phone format")
                    self.createdLabel.text = "Profile Not Updated!, Phone number should start with [+966]"
                    self.createdLabel.isHidden = false
                }
            }//if newPhone!.count == 13
             else{
                print("phone no is less than 13")
                self.createdLabel.text = "Profile Not Updated!, Phone number should contain 9 digits"
                self.createdLabel.isHidden = false
                  }
                }//else
              }//  Auth.auth().currentUser?.updateEmail(to: newEmail!) {
            }// if Auth.auth().currentUser != nil
        }// if newName != nil ....
    }
    
    @IBAction func cancle(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
}
