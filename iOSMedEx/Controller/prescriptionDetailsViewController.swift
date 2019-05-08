//
//  prescriptionDetailsViewController.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 17/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase
class prescriptionDetailsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let userID = Auth.auth().currentUser?.uid
    //defining firebase reference var
    var refPrescription: DatabaseReference!
    
    //list to store all the medicines
    var medicinesList = [prescriptionDetails]()
    var prescriptionsRXs = [String]()
    var prescriptionkey : String?
    var RX : String?
    var checkRX : String?
    var isOrderd = false
    @IBOutlet weak var prescriptionDetailesTable: UITableView!
    
    @IBOutlet weak var orderButton: UIButton!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicinesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        medicinesTableViewCell
        //the prescription object
        let medicine: prescriptionDetails
        //getting the prescriptions of selected position
        medicine = medicinesList[indexPath.row]
        
        //adding values to labels
        cell.name.text = medicine.name
        cell.dose.text = medicine.dose
        cell.frequency.text = medicine.frequency
        cell.quantity.text = medicine.quantity
        cell.nextRefillDate.text = medicine.nextRefillDate
        cell.relatedDetails.text = medicine.relatedDetails
        //returning cell
        return cell
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        orderButton.layer.cornerRadius = 30
        orderButton.layer.masksToBounds = true
        
        
        
        refPrescription = Database.database().reference().child("users").child(userID!).child("Prescriptions").child(self.prescriptionkey!);
        //observing the data changes
        refPrescription.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.medicinesList.removeAll()
                
                //iterating through all the values
                for medicines in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let medicineObject = medicines.value as? [String: AnyObject]
                    let medID = medicines.key
                    let name = medicineObject?["Name"]
                    let dose = medicineObject?["Doze"]
                    let frequency = medicineObject?["Frequency"]
                    let quantity = medicineObject?["Quantity"]
                    let nextRefillDate = medicineObject?["nextRefillDate"]
                    let relatedDetails = medicineObject?["RelatedDetails"]
                    
                    
                    //creating artist object with model and fetched values
                    if((name != nil) && (dose != nil) && (frequency != nil) && (quantity != nil)){
                        let medicine = prescriptionDetails (key: medID as String?, name: name as!String?, dose:dose as!String?, frequency:frequency as! String?, quantity:quantity as? String, nextRefillDate: nextRefillDate as!String?, relatedDetails: relatedDetails as!String?)
                        
                        //appending it to list
                        //   if ("\(String(describing Auth.auth().currentUser?.uid))".elementsEqual("\(inbody.userID)")) {}
                        self.medicinesList.append(medicine)}
                }
                
                //reloading the tableview
                self.prescriptionDetailesTable.reloadData()
            }
        })
        self.refPrescription = Database.database().reference().child("OrdersRXs")
        self.refPrescription.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.prescriptionsRXs.removeAll()
                
                //iterating through all the values
                for RXs in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    
                    let RXObject = RXs.value as? [String: AnyObject]
                    let orderRX = (RXObject?["RX"] as! String)
                    
                    
                    print ("Loop RX :\(orderRX)")
                    self.prescriptionsRXs.append(orderRX)
                    
                    
                } // End for loop
                
            } // End if
            
        } ) // End ovserve , snapshot */
        
        
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        for RXs in prescriptionsRXs {
            guard let checkRx = self.RX else { return }
            print ("self RX :\(String(describing: checkRx))")
            if (RXs == checkRx) {
                self.isOrderd = true
                let alertController = UIAlertController(title: "This prescription has already been ordered", message: "Your order has already been sent to the pharmacist, please wait for the approval", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)}
        }
        if (!isOrderd){
            var ref1 = Database.database().reference().child("users").child(self.userID!).child("Orders").child(self.RX!)
            var  ref2 = Database.database().reference().child("Orders").child(self.RX!)
            
            
            for medicine in self.medicinesList {
                let key = medicine.key!
                let name = medicine.name!
                let dose = medicine.dose!
                let frequency = medicine.frequency!
                let quantity = medicine.quantity!
                var nextRefillDate = medicine.nextRefillDate
                if ( nextRefillDate == nil){
                    nextRefillDate = "-"}
                var relatedDetails = medicine.relatedDetails
                if ( relatedDetails == nil){
                    relatedDetails = "-"}
                
                //Fetching patient MRN
                self.refPrescription = Database.database().reference()
                self.refPrescription.child("users").child(self.userID!).observeSingleEvent(of:
                    .value, with: { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        let  MRN = value?["MRN"] as? String ?? ""
                        
                        ref1 = Database.database().reference().child("users").child(self.userID!).child("Orders").child(self.RX!).child(key)
                        ref2 = Database.database().reference().child("Prescription Orders").child(self.RX!).child(key)
                        let order =  ["Name" :name as String  , "Doze": dose as String ,"Frequency": frequency as String , "Quantitiy": quantity as String , "NextRefillDate": nextRefillDate  , "RelatedDetails": relatedDetails, "Price" : "0", "MRN": MRN as String,"OrderStatus" : "Pending"]
                        ref1.setValue(order)
                        ref2.setValue(order)
                        let alertController = UIAlertController(title: "Your order has been sent!", message: "Your order has been sent successfully to the pharmacist, please wait for the approval", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                }
                )}
            let orderRXs = ["RX" : self.RX]
            self.refPrescription.child("OrdersRXs").childByAutoId().setValue(orderRXs)
        }
    }
    
    //Function to make table view backgound clear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    
    
    
    
}



/* self.refPrescription = Database.database().reference()
 self.refPrescription.child("users").child(self.userID!).observeSingleEvent(of:
 .value, with: { (snapshot) in
 
 let value = snapshot.value as? NSDictionary
 let  MRN = value?["MRN"] as? String ?? ""
 let phoneNo = value?["PhoneNo"] as? String ?? ""
 
 let date = Date()
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "dd/MM/yyyy"
 let dateString = dateFormatter.string(from: (date))
 self.refPrescription = Database.database().reference()
 self.refPrescription.child("users").child(self.userID!).child("Address").observeSingleEvent(of:
 .value, with: { (snapshot) in
 
 let value = snapshot.value as? NSDictionary
 let  Neighborhood = value?["Neighborhood"] as? String ?? ""
 let  AdditionalNo = value?["AdditionalNo"] as? String ?? ""
 let  BuildingNo = value?["BuildingNo"] as? String ?? ""
 let  City = value?["City"] as? String ?? ""
 let  PostalCode = value?["Postal Code"] as? String ?? ""
 let  StreetName = value?["Street Name"] as? String ?? ""
 
 let orderInfo = ["MRN": MRN as String,"Order Date": dateString as String , "OrderStatus" : "Pending" , "RX" : self.RX, "phoneNo":phoneNo , "Neighborhood" :Neighborhood, "Price" : "-", "AdditionalNo" :AdditionalNo, "BuildingNo" :BuildingNo, "City" :City, "Postal Code" :PostalCode, "Street Name" :StreetName, "Assigned Driver" : "-"]
 let orderRXs = ["RX" : self.RX]
 self.refPrescription = Database.database().reference()
 self.refPrescription.child("OrdersRXs").childByAutoId().setValue(orderRXs)
 ref2 = Database.database().reference().child("Orders").child(self.RX!)
 ref2.child("Order Info").setValue(orderInfo)
 })
 
 
 })*/






