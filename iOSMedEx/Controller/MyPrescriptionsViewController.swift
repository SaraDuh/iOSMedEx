//
//  MyPrescriptionsViewController.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 16/05/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class MyPrescriptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let userID = Auth.auth().currentUser?.uid //"OB49NjJVlngFD6k8b1A37YO4Iqm1"
    //defining firebase reference var
    var refPrescription: DatabaseReference!
    
    //list to store all the prescriptions
    var prescriptionsList = [Prescription]()
    var prescriptionsKeys = [String]()
    var prescriptionsRXs = [String]()
    
    
    
    @IBOutlet weak var prescriptionsTable: UITableView!
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return prescriptionsList.count
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test back button
        self.view.backgroundColor = .blue
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        //end test
        
        //configuring firebase
        //  FirebaseApp.configure()
        //getting a reference to the node artists
        
        refPrescription = Database.database().reference().child("users").child(userID!).child("Prescriptions");
        //.child("PR1");
        //observing the data changes
        refPrescription.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.prescriptionsList.removeAll()
                
                //iterating through all the values
                for prescriptions in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let prescribtionObject = prescriptions.value as? [String: AnyObject]
                    let physicionName = prescribtionObject?["PrescribedPhysician"]
                    let prescriptionDate = prescribtionObject?["PrescriptionDate"]
                    let RX = prescribtionObject?["RX"]
                    let prescribtionId = prescriptions.key
                    
                    self.prescriptionsKeys.append(prescribtionId)
                    self.prescriptionsRXs.append(RX as! String)

                    
                    //creating artist object with model and fetched values
                    let prescription = Prescription (Rx: RX as! String , date: prescriptionDate as!String?, physicionName: physicionName as! String?)
                    
                    //appending it to list
                    //   if ("\(String(describing: Auth.auth().currentUser?.uid))".elementsEqual("\(inbody.userID)")) {}
                    self.prescriptionsList.append(prescription)
                }
                
                //reloading the tableview
                self.prescriptionsTable.reloadData()
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        myPrescriptionsTableViewCell
        //the prescription object
        let prescription: Prescription
        //getting the prescriptions of selected position
        prescription = prescriptionsList[indexPath.row]
        
        //adding values to labels
        cell.prescriptionNo.text = prescription.Rx
        cell.prescriptionDate.text = prescription.date
        cell.physicionName.text = prescription.physicionName
        
        //returning cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pID = storyboard?.instantiateViewController(withIdentifier: "prescriptionDetailsViewController") as? prescriptionDetailsViewController
        pID?.prescriptionkey = prescriptionsKeys[indexPath.row]
        pID?.RX = prescriptionsRXs[indexPath.row]
        self.navigationController?.pushViewController(pID!, animated: true)
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
