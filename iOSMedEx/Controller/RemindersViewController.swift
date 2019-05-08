//
//  RemindersViewController.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 07/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var delref : DatabaseReference!
        let userID = Auth.auth().currentUser?.uid
    var remindersList = [Reminders]()
    @IBOutlet weak var remindersTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return remindersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReminderTableViewCell
         //the order object
         let reminder: Reminders
         //getting the order of selected position
         reminder = remindersList[indexPath.row]
         //adding values to labels
         cell.title.text = reminder.title
         cell.subtitle.text = reminder.time
         //returning cell
         return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let reminderElement  = remindersList[indexPath.row]
        deleteReminder(id: reminderElement.id!)
    }
    func deleteReminder(id:String){
        delref = Database.database().reference().child("users").child(userID!).child("Reminders").child(id)
        delref.setValue(nil)
        let alertController = UIAlertController(title: "Reminder is removed", message: "The Reminder is successfully removed!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       ref = Database.database().reference().child("users").child(userID!).child("Reminders");
         ref.observe(DataEventType.value, with: { (snapshot) in
           
                //clearing the list
                self.remindersList.removeAll()
                //iterating through all the values
                for reminders in snapshot.children.allObjects as! [DataSnapshot] {
                    let reminderObject = reminders.value as? [String: AnyObject]
                    let Id = reminders.key
                    let remTime = reminderObject?["Time"]
                    let remTitle = reminderObject?["Title"]
                    //creating artist object with model and fetched values
                    let reminder1 = Reminders(title: remTime as! String?, time: remTitle as! String?, id: Id as String?)
                     self.remindersList.append(reminder1)
                }//end loop
                //reloading the tableview
                self.remindersTable.reloadData()
        
        })
    }
    


}
