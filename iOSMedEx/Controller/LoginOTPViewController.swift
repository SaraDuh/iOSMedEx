//
//  LoginOTPViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 15/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class LoginOTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var OTP1: UITextField!
    @IBOutlet weak var OTP2: UITextField!
    @IBOutlet weak var OTP3: UITextField!
    @IBOutlet weak var OTP4: UITextField!
    @IBOutlet weak var OTP5: UITextField!
    @IBOutlet weak var OTP6: UITextField!
    
    
    @IBOutlet weak var patientLogin: UIButton!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboard()
        
        patientLogin.layer.cornerRadius = 30
        patientLogin.layer.masksToBounds = true
        
        
        //OTP1
        OTP1.delegate = self
        OTP1.textAlignment = .center
        OTP1.setBottomBorder();        //OTP1.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        //OTP2
        OTP2.delegate = self
        OTP2.textAlignment = .center
        OTP2.setBottomBorder();       //OTP2.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        //OTP3
        OTP3.delegate = self
        OTP3.textAlignment = .center
        OTP3.setBottomBorder();        //OTP3.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        //OTP4
        OTP4.delegate = self
        OTP4.textAlignment = .center
        OTP4.setBottomBorder();        //OTP4.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        //OTP5
        OTP5.delegate = self
        OTP5.textAlignment = .center
       OTP5.setBottomBorder();    //OTP5.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        //OTP6
        OTP6.delegate = self
        OTP6.textAlignment = .center
        OTP6.setBottomBorder();        //OTP6.defaultTextAttributes.updateValue(22.0,forKey: NSAttributedString.Key.kern)
        
        // To start with OTP1
        OTP1.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == OTP1 {
                OTP2.becomeFirstResponder()
            }
            
            if textField == OTP2 {
                OTP3.becomeFirstResponder()
            }
            
            if textField == OTP3 {
                OTP4.becomeFirstResponder()
            }
            
            if textField == OTP4 {
                OTP5.becomeFirstResponder()
            }
            if textField == OTP5 {
                OTP6.becomeFirstResponder()
            }
            if textField == OTP6 {
                OTP6.resignFirstResponder()
            }
            
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == OTP2 {
                OTP1.becomeFirstResponder()
            }
            if textField == OTP3 {
                OTP2.becomeFirstResponder()
            }
            if textField == OTP4 {
                OTP3.becomeFirstResponder()
            }
            if textField == OTP5 {
                OTP4.becomeFirstResponder()
            }
            if textField == OTP6 {
                OTP5.becomeFirstResponder()
            }
            if textField == OTP1 {
                OTP1.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
    

    @IBAction func verifyLoginOTP(_ sender: Any) {
        //print ("OTP: \(OTP!)")
        guard let textOTP1 = OTP1.text else { return }
        guard let textOTP2 = OTP2.text else { return }
        guard let textOTP3 = OTP3.text else { return }
        guard let textOTP4 = OTP4.text else { return }
        guard let textOTP5 = OTP5.text else { return }
        guard let textOTP6 = OTP6.text else { return }
        
        let OTP = "\(textOTP1)\(textOTP2)\(textOTP3)\(textOTP4)\(textOTP5)\(textOTP6)"
        
        print (OTP)
        
        if OTP == "" {
            print ("Verification code is empty")
            let alertController = UIAlertController(title: "Empty Field!", message: "Please enter the verification code you received", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            // clear OTP
            self.OTP1.text = ""
            self.OTP2.text = ""
            self.OTP3.text = ""
            self.OTP4.text = ""
            self.OTP5.text = ""
            self.OTP6.text = ""
        }
        else {
            guard let verificationID = userDefault.string(forKey: "verificationID") else { return }
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: OTP)
            
            Auth.auth().signInAndRetrieveData(with: credential) {
                (success, error) in
                if error == nil {
                    print (success!)
                    print ("User signed in....")
                    //segue and stuff
                    //self.performSegue(withIdentifier: "goToPatientHomepage", sender: self)
                    let tabCont = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
                    self.present(tabCont, animated: true, completion: nil)
                    
                    // clear OTP
                    self.OTP1.text = ""
                    self.OTP2.text = ""
                    self.OTP3.text = ""
                    self.OTP4.text = ""
                    self.OTP5.text = ""
                    self.OTP6.text = ""
                    
                } else {
                    print ("Somthing went wrong... \(String(describing: error?.localizedDescription))")
                    let alertController = UIAlertController(title: "Error!", message: "Invalid verification code", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    // clear OTP
                    self.OTP1.text = ""
                    self.OTP2.text = ""
                    self.OTP3.text = ""
                    self.OTP4.text = ""
                    self.OTP5.text = ""
                    self.OTP6.text = ""
                }
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //self.navigationController?.setNavigationBarHidden(false, animated: false)
//        tabBarController?.tabBar.isHidden = false
//    }
 
    
}
