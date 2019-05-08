//
//  ReminderTableViewController.swift
//  iOSMedEx
//
//  Created by Deema on 17/06/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {
    
    // Properties
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current

    
    override func viewDidLoad() {
        super.viewDidLoad()
tableView.register(UINib.init(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "reminderCell")
       
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // load saved reminders, if any
       // if let savedReminders = loadReminders() {
           // reminders += savedReminders
       // }
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        // Configure the cell...
        let reminder = reminders[indexPath.row]
        // Fetches the appropriate info if reminder exists
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time as Date)
        return cell
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let toRemove = reminders.remove(at: indexPath.row)
            UIApplication.shared.cancelLocalNotification(toRemove.notification)
            //saveReminders()
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
    
  /*  @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddReminderViewController, let reminder = sourceViewController.reminder {
            // add a new reminder
            let newIndexPath = NSIndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
    
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save reminders...")
        }
    }
    
    func loadReminders() -> [Reminder]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }
    
*/

    
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
