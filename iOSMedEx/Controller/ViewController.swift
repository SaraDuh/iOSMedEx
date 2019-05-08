//
//  ViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 13/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {

    
    
    @IBOutlet weak var LOGIN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LOGIN.layer.cornerRadius = 30
        LOGIN.layer.masksToBounds = true
        
        //To hide back button after logging out
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //If there is a logged in user, by pass this screen and go straight to role hompage
        
//        if Auth.auth().currentUser != nil {
//
//            let userID = Auth.auth().currentUser?.uid
//            let ref = Database.database().reference().root
//            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {     (snapshot) in
//
//                let snapDict = snapshot.value as? NSDictionary
//
//                let role = snapDict?["Role"] as? String ?? ""
//                print(role)
//
//                if (role == "Patient") {
//                    print ("Login succssful! Hello patient")
//                    self.performSegue(withIdentifier: "goToPatientHomepage", sender: self)}
//                else if (role == "Driver") {
//                    print ("Login succssful! Hello driver")
//                    self.performSegue(withIdentifier: "goToDriverHomePage", sender: self)}
//                else {
//                    print ("Sorry, you're not MedEx user")}
//            })
        
//        }
        
        // To create Admin accont
          /*  FirebaseApp.configure()
        
            let ref = Database.database().reference().root
            
            let userID = Auth.auth().currentUser!.uid
            ref.child("users").child(userID).setValue(["Name": "Admin", "Email": "Admin@MedEx.com", "Role": "Admin"])
*/
    }
    
//    // The 2 functions here to hide navigation bar
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        // Show the Navigation Bar
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        // Hide the Navigation Bar
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //self.navigationController?.setNavigationBarHidden(false, animated: false)
//        tabBarController?.tabBar.isHidden = false
//    }




}
