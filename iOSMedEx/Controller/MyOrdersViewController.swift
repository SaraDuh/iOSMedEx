//
//  MyOrdersViewController.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase
class MyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
var ref2 = Database.database().reference()
    var OrdersList = [PrescribtionOrder]()
    var ordersKeys = [String]()
    var medIDs = [String]()
    var isOrderd = false
    var isCart = ""
    let userID = Auth.auth().currentUser!.uid
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrdersList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        myOrdersTableViewCell
        //the prescription object
        let order: PrescribtionOrder
        //getting the prescriptions of selected position
        order = OrdersList[indexPath.row]
        
        //adding values to labels
        cell.orderRx.text = order.OrderRX
        cell.medName.text = order.medName
        cell.orderStatus.text = order.OrderStatus
        if (order.medPrice == "0"){
        cell.price.text = "Not priced yet"
        } else {
            cell.price.text = "\(order.medPrice ?? "0") SR"
        }
        
        let green = hexStringToUIColor(hex: "#2ECC71")
        let blue = hexStringToUIColor(hex: "#1977E1")
        let clickable = hexStringToUIColor(hex: "#05B0F5")
        let unclickable = hexStringToUIColor(hex: "#D6DBE0")
        
    
        if (order.OrderStatus == "Approved") {
            cell.orderStatus.textColor = green
             cell.addToCart.isEnabled = true
             cell.addToCart.backgroundColor = clickable
        }
        if (order.OrderStatus == "Denied") {
            cell.orderStatus.textColor = UIColor.red
           cell.addToCart.isEnabled = false
         cell.addToCart.backgroundColor = unclickable
        }
        if (order.OrderStatus == "Pending") {
            cell.orderStatus.textColor = UIColor.gray
            cell.addToCart.isEnabled = false
            cell.addToCart.backgroundColor = unclickable
        }
        if (order.OrderStatus == "On-Delivery") {
            cell.orderStatus.textColor = UIColor.orange
             cell.addToCart.isEnabled = false
            cell.addToCart.backgroundColor = unclickable
        }
        if (order.OrderStatus == "Delivered") {
            cell.orderStatus.textColor = blue
             cell.addToCart.isEnabled = false
                cell.addToCart.backgroundColor = unclickable
        }
        if (order.OrderStatus == "Order Sent") {
            cell.orderStatus.textColor = UIColor.black
            cell.addToCart.isEnabled = false
            cell.addToCart.backgroundColor = unclickable
        }
        
        
        cell.addToCart.layer.cornerRadius = 15
        cell.addToCart.layer.masksToBounds = true
        //returning cell
        return cell
    }
    
    
    @IBOutlet weak var myOrdersTable: UITableView!
    
    var refOrders = Database.database().reference()
    var refmedIDs = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Back button
        self.view.backgroundColor = .blue
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        //end Back button
        
        refmedIDs = Database.database().reference().child("Medices IDs")
        refmedIDs.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                self.medIDs.removeAll()
                for medIDs in snapshot.children.allObjects as! [DataSnapshot] {
                    let medicineObject = medIDs.value as? [String: AnyObject]
                    let medID = medicineObject?["medID"]
                    self.medIDs.append(medID as! String) }
            } })
        
        refOrders = Database.database().reference().child("users").child(userID).child("Orders")
        refOrders.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for Orders in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let orderRX = Orders.key
                    
                    
                    self.ref2 = Database.database().reference().child("users").child(self.userID).child("Orders").child(orderRX)
                    self.ref2.observe(DataEventType.value, with: { (snapshot) in
                        
                        //if the reference have some values
                        if snapshot.childrenCount > 0 {
                            for Medicines in snapshot.children.allObjects as! [DataSnapshot] {
                                let medicineObject = Medicines.value as? [String: AnyObject]
                                let medID = Medicines.key
                                let medName = medicineObject?["Name"]
                                let medPrice = medicineObject?["Price"]
                                let OrderStatus1 = medicineObject?["OrderStatus"]
                                
                                
                                //creating artist object with model and fetched values
                                
                                let order = PrescribtionOrder (OrderRX: orderRX as String?, medID : medID as String? , medName: medName as! String?, medPrice : medPrice as! String? , OrderStatus: OrderStatus1 as! String?)
                                
                                //appending it to list
                                self.OrdersList.append(order)
                                
                            }
                        }
                        
                        //reloading the tableview
                        
                        self.myOrdersTable.reloadData()
                    })
                }
            }
            
        })
        // Do any additional setup after loading the view.
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @IBAction func addToCart(_ sender: Any) {
        self.isOrderd = false
        guard let cell = (sender as AnyObject).superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = myOrdersTable.indexPath(for: cell)
        let x = indexPath?.row
        var orderToCart : PrescribtionOrder
        orderToCart = OrdersList [x!]
        let orderRX = OrdersList[x!].OrderRX
        let  medID = OrdersList[x!].medID
        let orderStatus = OrdersList[x!].OrderStatus
        print (orderStatus as Any)
        for IDs in medIDs {
            guard let checkIDs = orderToCart.medID else { return }
            print ("checkID :\(String(describing: checkIDs))")
            if (checkIDs == IDs && orderStatus == "Approved") {
                self.isOrderd = true
                let alertController = UIAlertController(title: "Already added", message: "This medicine is already added to the card, see other medicines", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                break }
        }
        if (orderStatus == "Pending") {
            let alertController = UIAlertController(title: "Order hasn't been approved", message: "Order hasn't been approved yet, please wait for the pharmacist approval", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if (orderStatus == "Denied") {
            
            let alertController = UIAlertController(title: "Order denied", message: "Your order is denied, chick if it has a substitution ", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if (orderStatus == "Delivered") {
            let alertController = UIAlertController(title: "Medicine was ordered before", message: "This medicine has been ordered, if there is a refill it will be available on the next refill date", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if (orderStatus == "On-Delivery" ) {
            let alertController = UIAlertController(title: "Medicine was ordered before", message: "Medicine is On-Delivery, Driver will contact you as soon as possible", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if(!isOrderd && orderStatus == "Approved"){
            let ref = Database.database().reference()
            let key = ref.childByAutoId().key
            let userID = Auth.auth().currentUser!.uid
            print(orderToCart.medName as Any)
            print(orderToCart.OrderRX as Any)
            let OTC = ["Name" : (orderToCart.medName as! String) , "Price" : (orderToCart.medPrice as! String) , "RX" : (orderToCart.OrderRX as! String) , "medID" : (orderToCart.medID as! String)]
            //HEEEEEEEREEEEEEEE HELLO
            ref.child("Medices IDs").child(orderToCart.medID!).child("medID").setValue(orderToCart.medID!)
            ref.child("users").child(userID).child("Cart").child(orderToCart.medID!).setValue(OTC)
            
            
            let alertController = UIAlertController(title: "Added successfully!", message: "Your order has been added successfully to the cart", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
