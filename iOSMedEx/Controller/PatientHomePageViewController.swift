//
//  PatientHomePageViewController.swift
//  iOSMedEx
//
//  Created by Deema on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class PatientHomePageViewController: UIViewController {
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var myPrescriptions: UIButton!
    
    @IBOutlet weak var myRefills: UIButton!
    
    @IBOutlet weak var myOrders: UIButton!
    
    @IBOutlet weak var reminders: UIButton!
    
    var refPrescription: DatabaseReference!
    var refMedicine: DatabaseReference!
    var refRefill: DatabaseReference!
    var refReminders: DatabaseReference!
    var refillList = [Refill]()
    var refValue1: DatabaseReference!
    var refValue2: DatabaseReference!
    //Varabile to generate Medicine ID
    var sixUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 4 leading zeros with a random number 0...9999
            result = String(format:"%06d", arc4random_uniform(1000000) )
            // generate another random number if the set of characters count is less than four
        } while result.count < 6
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to hide backbutton
        navigationItem.setHidesBackButton(true, animated: true)
    

        
        myPrescriptions.layer.cornerRadius = 30
        myPrescriptions.layer.masksToBounds = true
        
        myRefills.layer.cornerRadius = 30
        myRefills.layer.masksToBounds = true
        
        myOrders.layer.cornerRadius = 30
        myOrders.layer.masksToBounds = true
        
        reminders.layer.cornerRadius = 30
        reminders.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
 
        refPrescription = Database.database().reference().child("users").child(userID!).child("Prescriptions");
        
        refPrescription.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                 print ("Number of prescriptions: \(snapshot.childrenCount)")
                                //clearing the list
                
                //iterating through all the values
                for prescriptions in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let prescribtionObject = prescriptions.value as? [String: AnyObject]
                    let physicionName = prescribtionObject?["PrescribedPhysician"]
                    let prescriptionDate = prescribtionObject?["PrescriptionDate"]
                    let RX = prescribtionObject?["RX"]
                    let prescribtionId = prescriptions.key
                    
                    print("")
                    print ("prescribtionId: \(prescribtionId)")
                    print ("RX: \(RX)")
                    print ("physicionName: \(physicionName)")
                    print ("prescriptionDate: \(prescriptionDate)")
                    
                    
                    self.refPrescription.child(prescribtionId).observe(DataEventType.value, with: { (snapshot) in
                        
                        //if the reference have some values
                        if snapshot.childrenCount > 0 {
                            //clearing the list
                            
                            //iterating through all the values
                            for medicines in snapshot.children.allObjects as! [DataSnapshot] {
                                let medicineObject = medicines.value as? [String: AnyObject]
                                let medID = medicines.key
                                
                                if (medID != "PrescribedPhysician" && medID != "PrescriptionDate" && medID != "RX") {
                                    
                                let name = medicineObject?["Name"]
                                let dose = medicineObject?["Doze"]
                                let frequency = medicineObject?["Frequency"]
                                let quantity = medicineObject?["Quantity"]
                                    var refill = medicineObject?["Refill"]
                                let nextRefillDate = medicineObject?["nextRefillDate"]
                                guard let nextRefillDate1 = nextRefillDate else { return }
                                let relatedDetails = medicineObject?["RelatedDetails"]
                                
                                print("")
                                print("medID: \(medID)")
                                print("name: \(name)")
                                print("dose: \(dose)")
                                print("frequency: \(frequency)")
                                print("quantity: \(quantity)")
                                print("nextRefillDate: \(nextRefillDate)")
                                print ("non-optional nextRefillDate: \(nextRefillDate1)")
                                print ("Refill possibility: \(refill)")
                                print("relatedDetails: \(relatedDetails)")
                                    

                                    //create new RX
                                    let refillRX = self.sixUniqueDigits
                                    let refillPossibility = refill as! String
                                    if (refillPossibility == "True")
                                    {
                                        print ()
                                        print ("Refill Posibility: \(refillPossibility)")
                                        print ("Refill Date After formatting (String): \(nextRefillDate1)")
                                        
                                        
                                        
                                        //test date comparasion

                                        
                                        let now = Date()
                                        let formatter = DateFormatter()
                                        formatter.timeZone = TimeZone.current
                                        formatter.dateFormat = "yyyy-MM-dd"
                                        let dateString = formatter.string(from: now)
                                        
                                        print ("Current Date after formant(String): \(dateString)")
                                        self.refValue1 = Database.database().reference().child("users").child(self.userID!).child("Prescriptions").child(prescribtionId).child(medID)
                                        self.refValue2 = Database.database().reference().child("users").child(self.userID!).child("Prescriptions").child(prescribtionId).child(medID)
                                        
                                        if ((nextRefillDate1.compare(dateString) == .orderedSame) || (nextRefillDate1.compare(dateString) == .orderedAscending)){
                                            print ("Dates the same")
                                            
                                            // Here change Refill = False & Next Refill Date = -

                                            self.refValue1.child("Refill").setValue("False")
                                            self.refValue2.child("nextRefillDate").setValue("-")
                                            
                                            
                                            self.refRefill = Database.database().reference().child("users").child(self.userID!).child("Refills").child(refillRX).childByAutoId()
                                            
                                            let refill1 = ["PrescribedPhysician": physicionName as Any, "Refill Date": nextRefillDate1 as Any, "RX": RX as Any, "Prescription ID": prescribtionId as Any, "Dose": dose as Any, "Frequency": frequency as Any, "Name": name as Any, "Quantity": quantity as Any, "Related details": relatedDetails as Any, "nextRefillDate": "-"]
                                            
                                            self.refRefill.setValue(refill1)
                                            

                                            // Here sent notification
                                            let content = UNMutableNotificationContent()
                                            content.title = "Prescription Refill"
                                            content.subtitle = ""
                                            //content.body = "Your InBody has been reserved in \(dateString)"
                                            content.body = "You have a new refill! Have a look and order it now."
                                            content.badge = 1
                                            
                                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                                            
                                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                           
                                        } else {
                                            print ("Dates NOT the same ")
                                        }
                                        
                                    } else {
                                        print ("This medicine has no Refill")
                                    }
                                }
                            }
                        }
                    }) //end observe
                }
            }
        })
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
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
    
    
//    @objc func handleSignOutButtonTapped() {
//        
//        do {
//            try Auth.auth().signOut()
//            self.navigationController?.popToRootViewController(animated: true)
//            print ("User logged out")
//        } catch let error {
//            print ("Failed to logout with error", error)
//        }
//    }
    

   

}
