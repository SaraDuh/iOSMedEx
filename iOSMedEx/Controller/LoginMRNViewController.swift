//
//  LoginMRNViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 15/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = .none
        //self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class LoginMRNViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userMRN: UITextField!
    @IBOutlet weak var ButtonNext: UIButton!
    
    let userDefault = UserDefaults.standard
    
    var MRNList = [MRNandPhoneNo]()
    var MRNRef:  DatabaseReference!
    var MRN = ""
    var userPhoneNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        // Do any additional setup after loading the view.
        
        ButtonNext.layer.cornerRadius = 30
        ButtonNext.layer.masksToBounds = true
        
        userMRN.delegate = self
        userMRN.textAlignment = .center
        userMRN.setBottomBorder();       userMRN.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func MRNentered(_ sender: Any) {
        //if MRN is empty
        if userMRN.text == "" {
            print ("MRN field is empty")
            let alertController = UIAlertController(title: "Empty Field!", message: "Please enter your Medical Record Number", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //if MRN not empty
            self.MRNRef = Database.database().reference().child("MRNs & PhoneNos");
            self.MRNRef.observe(DataEventType.value, with: { (snapshot) in
                
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    //clearing the list
                    self.MRNList.removeAll()
                    
                    //iterating through all the values
                    for MRNsandPhoneNos in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let MRNObject = MRNsandPhoneNos.value as? [String: AnyObject]
                        self.MRN  = MRNObject?["MRN"] as! String
                        self.userPhoneNo = MRNObject?["PhoneNo"] as! String
                        
                        if (self.userMRN.text == self.MRN ) {
                            print ("Entered MRN:\(String(describing: self.userMRN))")
                            print ("Found MRN:\(String(describing: self.MRN))")
                            print ("phoneNO:\(String(describing: self.userPhoneNo))")
                            break;
                        }
                    }// end loop
                    
                    if(self.userMRN.text != self.MRN ) {
                        // invalid MRN
                        print ("Invalid MRN")
                        let alertController = UIAlertController(title: "Error!", message: "Your Medical Record Number is invalid", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        // clear MRN
                        self.userMRN.text = ""
                    }
                    else {
                        // Valid MRN
                        print ("Valid MRN")
                        PhoneAuthProvider.provider().verifyPhoneNumber(self.userPhoneNo, uiDelegate: nil) { (verificationID, error) in
                            if error == nil {
                                //if success
                                print ("Verification ID:")
                                print(verificationID as Any)
                                guard let verifyID = verificationID else { return }
                                self.userDefault.set(verifyID, forKey: "verificationID")
                                self.userDefault.synchronize()
                                self.performSegue(withIdentifier: "goToOTP", sender: self)
                                // clear MRN
                                self.userMRN.text = ""
                            } else {
                                //if fail
                                print ("Unable to get secret verificationID from firebase")
                                print (error!)
                                let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                                //clear MRN
                                self.userMRN.text = ""
                            }
                        }
                    } // end valid MRN
                }
            })
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //self.navigationController?.setNavigationBarHidden(false, animated: false)
//        tabBarController?.tabBar.isHidden = false
//    }

 

}

