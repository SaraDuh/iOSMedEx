//
//  DriverLoginViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 21/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class DriverLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var driverEmail: UITextField!
    @IBOutlet weak var driverPassword: UITextField!
    
    @IBOutlet weak var driverLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboard()
        
        driverLogin.layer.cornerRadius = 30
        driverLogin.layer.masksToBounds = true
        
        driverEmail.delegate = self
        driverEmail.setBottomBorder();
        
        driverPassword.delegate = self
        driverPassword.setBottomBorder();
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: driverEmail.text!, password: driverPassword.text!) { (user, error) in
            if error != nil {
                print (error!)
                
                self.view.endEditing(true)
                
                if (self.driverEmail.text?.isEmpty)! || (self.driverPassword.text?.isEmpty)!
                {
                    let alert = UIAlertController(
                        title: "Invalid Login!",
                        message: "Please fill your e-mail and password",
                        preferredStyle: UIAlertController.Style.alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                    
                else {
                    // Handel exception when invalid email or password
                    print("error")
                    let alertController = UIAlertController(title: "Invalid Login!", message: "Incorrect credentials", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    print(error?.localizedDescription as Any)
                }
                
            } else {
                let userID = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().root
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {     (snapshot) in
                    
                    let snapDict = snapshot.value as? NSDictionary
                    
                    let role = snapDict?["Role"] as? String ?? ""
                    print(role)
                    
                    if (role == "Driver") {
                        print ("Succssful login! Hello Driver")
                        self.performSegue(withIdentifier: "goToDriverHomePage", sender: self)
                    } else {
                        print ("Sorry you are not member")
                        
                    }
                })
                
            }
        }
    }
    


}
