//
//  CollectionViewCell.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//


//
//  MyPrescribtions.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class MyPrescribtions: UIViewController {
 
    //defining firebase reference var
    var refPrescription: DatabaseReference!
    
    //list to store all the prescriptions
  //  var prescriptionsList = [prescriptionsModel]()
    
    
    
    
  /*  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return prescriptionsList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        myPrescriptionsTableViewCell
        //the prescription object
        let prescription: prescriptionsModel
        //getting the prescriptions of selected position
        prescription = prescriptionsList[indexPath.row]
        
        //adding values to labels
        cell.prescriptionDate.text = prescription.date
        cell.physiconName.text = prescription.physicionName
        
        //returning cell
        return cell
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuring firebase
        FirebaseApp.configure()
        
        //getting a reference to the node artists
        refPrescription = Database.database().reference().child("users").child("Prescriptions");
        //observing the data changes
       /* refPrescription.observe(DataEventType.value, with: { (snapshot) in
            
           //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.prescriptionsList.removeAll()
                
                //iterating through all the values
                for prescriptions in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let prescribtionObject = prescriptions.value as? [String: AnyObject]
                    let physicionName = prescribtionObject?["Prescribed Physician"]
                    let prescribtionDate = prescribtionObject?["Prescription Date"]
                    
                    //creating artist object with model and fetched values
                    let prescription = prescriptionsModel (date: prescribtionDate as!String?, physicionName: physicionName as! String?)
                    
                    //appending it to list
                    //   if ("\(String(describing: Auth.auth().currentUser?.uid))".elementsEqual("\(inbody.userID)")) {}
                    self.prescriptionsList.append(prescription)
                }
                
                //reloading the tableview
                self.prescriptionsTable.reloadData()
            }
        })*/
        
        // Do any additional setup after loading the view.
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

