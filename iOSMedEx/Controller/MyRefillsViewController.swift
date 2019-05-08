//
//  MyRefillsViewController.swift
//  iOSMedEx
//
//  Created by Aseel Mohimeed on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class MyRefillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    //Varabile to generate Medicine ID
    //    var sixUniqueDigits: String {
    //        var result = ""
    //        repeat {
    //            // create a string with up to 4 leading zeros with a random number 0...9999
    //            result = String(format:"%06d", arc4random_uniform(1000000) )
    //            // generate another random number if the set of characters count is less than four
    //        } while result.count < 6
    //        return result
    //    }
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var refillsTable: UITableView!
    
    
    //defining firebase reference var
    var refPrescription: DatabaseReference!
    var refMedicine: DatabaseReference!
    var refRefill: DatabaseReference!
    
    //list to store all the prescriptions (I dunno maybe I dont need it)
    var prescriptionsList = [Prescription]()
    var prescriptionsRXs = [String]()
    
    //list to store all the refills
    var refillsList = [Refill]()
    
    
    var prescriptionkey : String?
    var RX : String?
    var checkRX : String?
    var isOrderd = false
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refillsList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Work in prescriptionsRXs array
        self.refPrescription = Database.database().reference().child("OrdersRXs")
        print ("")
        print ("In the viewDidLoad()")
        self.refPrescription.observe(DataEventType.value, with: { (snapshot) in
            self.prescriptionsRXs.removeAll() // clear the list
            print ("In the viewDidLoad(): Previous Orders RXs:")
            if snapshot.childrenCount > 0 {
                //var orderRX = "-"
                for RXs in snapshot.children.allObjects as! [DataSnapshot] {
                    let RXObject = RXs.value as? [String: AnyObject]
                    let orderRX = (RXObject?["RX"]) as! String
                    print (orderRX)
                    self.prescriptionsRXs.append(orderRX)
                }
            }
            print ("In the viewDidLoad(): Previous Orders RX after my array:")
            print (self.prescriptionsRXs)
        })
        
        //Back button
        self.view.backgroundColor = .blue
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        //end Back button
        
        
        
        // Load Refills in TableView
        refPrescription = Database.database().reference().child("users").child(userID!).child("Refills");
        refPrescription.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                //self.refillsList.removeAll()
                
                //iterating through all the values
                for medicines in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let Rx = medicines.key
                    print ("")
                    print ("Test Loop 1")
                    print ("Rx: \(Rx)")
                    print ("")
                    
                    //get medicines
                    self.refPrescription = Database.database().reference().child("users").child(self.userID!).child("Refills").child(Rx);
                    self.refPrescription.observe(DataEventType.value, with: { (snapshot) in
                        //if the reference have some values
                        if snapshot.childrenCount > 0 {
                            //clearing the list
                            //self.refillsList.removeAll()
                            
                            //iterating through all the values
                            for medicines in snapshot.children.allObjects as! [DataSnapshot] {
                                //getting values
                                let medID = medicines.key
                                print ("Medicine ID: \(medID)")
                                let medicineObject = medicines.value as? [String: AnyObject]
                                let physicionName = medicineObject?["PrescribedPhysician"]
                                print (physicionName)
                                let medDose = medicineObject?["Dose"]
                                print (medDose)
                                let medFrequency = medicineObject?["Frequency"]
                                
                                let medName = medicineObject?["Name"]
                                let medQuantity = medicineObject?["Quantity"]
                                let medRefillDate = medicineObject?["Refill Date"]
                                let medRelatedDetails = medicineObject?["Related details"]
                                
                                if((physicionName != nil) && (medDose != nil) && (medFrequency != nil) && (medName != nil) &&  (medQuantity != nil) && (medRefillDate != nil)) {
                                    print("")
                                    print ("Test Loop 2")
                                    print("RX: \(Rx)")
                                    print ("Medicine ID: \(medID)")
                                    print("Physicion Name: \(String(describing: physicionName))")
                                    print("Dose: \(String(describing: medDose))")
                                    print("Frequency: \(String(describing: medFrequency))")
                                    print("Name: \(String(describing: medName))")
                                    print("Quantity: \(String(describing: medQuantity))")
                                    print("Refill Date: \(String(describing: medRefillDate))")
                                    print ("Relatedd Details: \(String(describing: medRelatedDetails))")
                                    
                                    //creating artist object with model and fetched values
                                    let refill = Refill (refillNo: Rx, medID: medID, date: medRefillDate as? String, physicionName: physicionName as? String , name: medName as? String, dose: medDose as? String, frequency: medFrequency as? String, quantity: medQuantity as? String, relatedDetails: medRelatedDetails as? String)
                                    self.refillsList.append(refill)
                                    
                                }
                            }//end loop 2
                            //reloading the tableview
                            self.refillsTable.reloadData()
                        }
                    })
                }//end loop 1
                //reloading the tableview
                self.refillsTable.reloadData()
            }
        })
    } //load method
    
    @IBAction func orderPressed(_ sender: Any) {
        isOrderd = false
        let ref = Database.database().reference()
        
        let refill1: Refill
        
        guard let cell = (sender as AnyObject).superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexPath = refillsTable.indexPath(for: cell)
        let x = indexPath?.row
        
        //getting the artist of selected position
        refill1 = refillsList [x!]
        let Rx = refill1.refillNo!
        
        print ("")
        print ("In orderPressed()")
        print ("Previous Orders RXs:")
        print (self.prescriptionsRXs)
        print ("Current Order RX: \(Rx)")
        
        
        //Compare current order with previous order RXs
        print ("")
        print ("Now inside the loop of my array [if (orderRx == Rx)] ")
        print ("Current order RXs in the array:")
        for orderRx in self.prescriptionsRXs {
            print (orderRx)
            if (orderRx == Rx){
                self.isOrderd = true
                print ("Previous Order RX: \(orderRx)")
                print ("Current Order RX: \(Rx)")
                print ("They are the same! Cannot order ")
                let alertController = UIAlertController(title: "This prescription has already been ordered", message: "Your order has already been sent to the pharmacist, please wait for the approval", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                break
            }
        }
        print ("")
        print ("Now outside the loop of my array")
        print ("Value of isOrdered: \(self.isOrderd)")
        
        if (!isOrderd){
            print ("There is no previous order for this prescription")
            
            //Fetching patient MRN
            self.refPrescription = Database.database().reference()
            self.refPrescription.child("users").child(self.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let MRN = value?["MRN"] as? String ?? ""
                
                let ref1 = ref.child("users").child(self.userID!).child("Orders").child(refill1.refillNo!).child(refill1.medID!)
                let ref2 = ref.child("Prescription Orders").child(refill1.refillNo!).child(refill1.medID!)
                
                let order = ["Name": refill1.name, "Doze": refill1.dose, "Frequency": refill1.frequency, "Quantitiy": refill1.quantity, "NextRefillDate": "-", "RelatedDetails": refill1.relatedDetails, "Price" : "-", "MRN": MRN, "OrderStatus" : "Pending"]
                ref1.setValue(order)
                ref2.setValue(order)
                let alertController = UIAlertController(title: "Your order has been sent!", message: "Your order has been sent successfully to the pharmacist, please wait for the approval", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            })
            //Add current order RX to OrdersRXs node
            let orderRXs = ["RX" : Rx]
            self.refPrescription = Database.database().reference().child("OrdersRXs")
            self.refPrescription.childByAutoId().setValue(orderRXs)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        myRefillsTableViewCell
        
        //the prescription object
        let refill: Refill
        //getting the prescriptions of selected position
        refill = refillsList[indexPath.row]
        
        //adding values to labels
        cell.refillNo.text = refill.refillNo
        cell.refillDate.text = refill.date
        cell.physicionName.text = refill.physicionName
        cell.name.text = refill.name
        cell.dose.text = refill.dose
        cell.frequency.text = refill.frequency
        cell.quantity.text = refill.quantity
        cell.relatedDetails.text = refill.relatedDetails
        cell.orderRefill.layer.cornerRadius = 15
        cell.orderRefill.layer.masksToBounds = true
        
        //returning cell
        return cell
    }
    
    //Function to make table view backgound clear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    
    func makeBackButton() -> UIButton {
        
        let backButtonImage = UIImage(named: "backbutton")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        backButton.setTitle("  Back", for: .normal)
        backButton.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        //UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1
        
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
}
