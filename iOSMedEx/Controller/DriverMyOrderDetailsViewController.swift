//
//  DriverMyOrderDetailsViewController.swift
//  iOSMedEx
//
//  Created by Deema on 26/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class DriverMyOrderDetailsViewController: UIViewController {
    
    
    
    var orderKey : String?
    let userID = Auth.auth().currentUser?.uid
    var refOrders: DatabaseReference!
    var ref: DatabaseReference!
    var RXref: DatabaseReference!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var patientNo: UILabel!
    @IBOutlet weak var patientAddress: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var patientAddress2: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var addCode: UILabel!
    var uid:   String?
    
    @IBOutlet weak var nh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refOrders = Database.database().reference().child("PayedOrders").child(self.orderKey!);
        
        refOrders.observeSingleEvent(of: .value, with: { (snapshot) in
            let OrderObject = snapshot.value as? [String: AnyObject]
            let orderNum  = self.orderKey
            let orderdate  = OrderObject?["OrderDate"]
            let orderStat  = OrderObject?["Status"]
            let patientNum  = OrderObject?["phoneNo"]
            let patientAdditionalNo  = OrderObject?["AdditionalNo"]
            let patientBuildingNo  = OrderObject?["BuildingNo"]
            let patientCity  = OrderObject?["City"]
            let patientNeighborhood  = OrderObject?["Neighborhood"]
            let patientPostalCode  = OrderObject?["PostalCode"]
            let patientStreetName  = OrderObject?["StreetName"]
            self.uid  = OrderObject?["UID"] as! String
            
            
            //appending it to list
            self.orderNo.text = orderNum
            self.orderDate.text = orderdate as? String
            self.orderStatus.text = orderStat as? String
            self.patientNo.text = patientNum as? String
            self.patientAddress.text = patientBuildingNo as? String
            self.street.text = patientStreetName as? String
            self.nh.text = patientNeighborhood as? String
            self.patientAddress2.text = patientCity as? String
            self.postCode.text = patientPostalCode as? String
            self.addCode.text = patientAdditionalNo as? String
        })
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var selectStatus: UIButton!
    @IBOutlet weak var onDel: UIButton!
    @IBOutlet weak var Del: UIButton!
    
    @IBOutlet var status: [UIButton]!
    @IBAction func handleSelection(_ sender: Any) {
        status.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    enum Statuses: String {
        case onDelivery = "On-Delivery"
        case Delivered = "Delivered"
    }
    
    @IBAction func selectionTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let status1 = Statuses(rawValue: title) else {
            return
        }
        
        switch status1 {
        case .onDelivery:
            for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
                selectStatus.setTitle(NSLocalizedString("On-Delivery", comment: ""), for: state)
            }
            print("onDelivery")
            refOrders = Database.database().reference().child("PayedOrders").child(self.orderKey!);
            let newValues = ["Status": "On-Delivery"]
            self.refOrders.updateChildValues(newValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                if error != nil{
                    print(error!)
                    return
                }
                //here change status in patient order and pres orders
                self.RXref = Database.database().reference().child("PayedOrders").child(self.orderKey!).child("RXs");
                
                 self.RXref.observe(DataEventType.value, with: { (snapshot) in
                 for rxs in snapshot.children.allObjects as! [DataSnapshot] {
                 let rx_idObj = rxs.value as? [String: AnyObject]
                 let medRX = rx_idObj?["RX"] as! String
                 let medID = rx_idObj?["ID"] as! String
                 print("here RXX")
                 print(medRX)
                 //change status for patient
                print("entering change status for patient code area")
                 let uOrderRef = Database.database().reference().child("users").child(self.uid!).child("Orders").child(medRX)
                 print("here inside rx reference. will it change????:(")
                 uOrderRef.child(medID).child("OrderStatus").setValue("On-Delivery")
                 print("CHANGED for patient")
                    //change status for presOrders
                    print("entering change status for presOrders code area")
                    let presOrderRef = Database.database().reference().child("Prescription Orders").child(medRX)
                    print("here inside rx for presOrders. will it change????:(")
                    presOrderRef.child(medID).child("OrderStatus").setValue("On-Delivery")
                    print("CHANGED for patient")
                 } //end of for
                 }) //end of cart snapshot
 
                //end change status in patient order and pres orders
                
                let alertController = UIAlertController(title: "Status Changed!", message: "The status has been changed to (On-Delivery) successfully!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                print("Status Changed Successfully")
            })
        case .Delivered:
            for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
                selectStatus.setTitle(NSLocalizedString("Delivered", comment: ""), for: state)
            }
            print("Delivered")
            refOrders = Database.database().reference().child("PayedOrders").child(self.orderKey!);
            let newValues = ["Status": "Delivered"]
            self.refOrders.updateChildValues(newValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                if error != nil{
                    print(error!)
                    return
                }
                //here change status in patient order and pres orders
                self.RXref = Database.database().reference().child("PayedOrders").child(self.orderKey!).child("RXs");
                
                self.RXref.observe(DataEventType.value, with: { (snapshot) in
                    for rxs in snapshot.children.allObjects as! [DataSnapshot] {
                        let rx_idObj = rxs.value as? [String: AnyObject]
                        let medRX = rx_idObj?["RX"] as! String
                        let medID = rx_idObj?["ID"] as! String
                        print("here RXX")
                        print(medRX)
                        //change status for patient
                        print("entering change status for patient code area")
                        let uOrderRef = Database.database().reference().child("users").child(self.uid!).child("Orders").child(medRX)
                        print("here inside rx reference. will it change????:(")
                        uOrderRef.child(medID).child("OrderStatus").setValue("Delivered")
                        print("CHANGED for patient")
                        //change status for presOrders
                        print("entering change status for presOrders code area")
                        let presOrderRef = Database.database().reference().child("Prescription Orders").child(medRX)
                        print("here inside rx for presOrders. will it change????:(")
                        presOrderRef.child(medID).child("OrderStatus").setValue("Delivered")
                        print("CHANGED for patient")
                    } //end of for
                }) //end of cart snapshot
                
                //end change status in patient order and pres orders
                let alertController = UIAlertController(title: "Status Changed!", message: "The status has been changed to (Delivered) successfully!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                print("Status Changed Successfully")
            })
        }
    }
}
