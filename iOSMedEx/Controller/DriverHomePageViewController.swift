//
//  DriverHomePageViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 18/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class DriverHomePageViewController: UIViewController {
    
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var myOrders: UIButton!
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile.layer.cornerRadius = 30
        profile.layer.masksToBounds = true
        
        myOrders.layer.cornerRadius = 30
        myOrders.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        
        //to hide backbutton
        navigationItem.setHidesBackButton(true, animated: true)
        
        navigationItem.title = "MedEx"
        
      
        //start get DAddress method
    let pID = self.storyboard?.instantiateViewController(withIdentifier: "DriverOrdersViewController") as? DriverOrdersViewController
        self.ref2 = Database.database().reference().child("users");
        self.ref2.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userObject = snapshot.value as? [String: AnyObject]
            let userArea = userObject?["DeliveryArea"]
            let areaString = userArea as! String
            print(areaString)
            pID?.DrNeighborhood = areaString

            
            
            //print(area1)
          //  pID?.area = area1
           // self.navigationController?.pushViewController(pID!, animated: true)
        }) // end get Driver Address method
     
        
    }

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            
            print ("User logged out")
        } catch let error {
            print ("Failed to logout with error", error)
        }
    }
}
