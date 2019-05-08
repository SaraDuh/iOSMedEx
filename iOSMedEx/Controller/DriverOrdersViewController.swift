//
//  DriverOrdersViewController.swift
//  iOSMedEx
//hello
//
//  Created by Deema on 24/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class DriverOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet weak var ordersTable: UITableView!
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var ordersList = [Order]()
    var ordersKeys = [String]()
    var DrNeighborhood : String?
    let userID = Auth.auth().currentUser?.uid
    

    override func viewDidLoad() {
      
        super.viewDidLoad()
        getArea()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DriverOrdersTableViewCell
        //the order object
        let order: Order
        //getting the order of selected position
        order = ordersList[indexPath.row]
        //adding values to labels
        cell.orderNo.text = order.OrderNo
        cell.orderDate.text = order.OrderDate
        cell.orderStatus.text = order.OrderStatus
        //returning cell
        return cell
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let pID = storyboard?.instantiateViewController(withIdentifier: "DriverMyOrderDetailsViewController") as? DriverMyOrderDetailsViewController
         pID?.orderKey = ordersKeys[indexPath.row]
     self.navigationController?.pushViewController(pID!, animated: true)
     }
    
    //Function to make table view backgound clear  //just copy
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    
    func getArea(){
        //start get DAddress method
        self.ref2 = Database.database().reference().child("users");
        self.ref2.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userObject = snapshot.value as? [String: AnyObject]
            let userArea = userObject?["DeliveryArea"]
            
            self.ref = Database.database().reference().child("PayedOrders");
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    print("inside if child > 0")
                    //clearing the list
                    self.ordersList.removeAll()
                    //iterating through all the values
                    for orders in snapshot.children.allObjects as! [DataSnapshot] {
                        print("inside orders loop")
                        //getting values
                        let orderObject = orders.value as? [String: AnyObject]
                        let orderId = orders.key
                        let orderDate = orderObject?["OrderDate"]
                        let orderStat = orderObject?["Status"]
                        let orderArea = orderObject?["Neighborhood"]
                        
                        //creating artist object with model and fetched values
                        let order = Order (OrderNo: orderId as String?, OrderDate: orderDate as! String?, OrderStatus: orderStat as! String?)
                        if userArea as! String == (orderArea as! String){
                            print("inside if area == ordArarea")
                            self.ordersList.append(order)
                            self.ordersKeys.append(orderId)
                        }
                    }
                    //reloading the tableview
                    self.ordersTable.reloadData()
                }
            })
            // Do any additional setup after loading the view.
            self.ordersTable.allowsMultipleSelectionDuringEditing = true
            
        }) // end get Driver Address method
        
        
    }
  
}

