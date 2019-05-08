//
//  reminderTESTViewController.swift
//  iOSMedEx
//
//  Created by Reem Aldughaither on 07/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class reminderTESTViewController: UIViewController, UITextFieldDelegate {

    var reminderRef: DatabaseReference!
    let userID = Auth.auth().currentUser!.uid


    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func savePressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Reminder Saved", message: "Your reminder has been saved successfully", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
        let name1 = titleField.text
        var time1 = datePicker.date
        let timeInterval = floor(time1.timeIntervalSinceReferenceDate/60)*60
        time1 = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
        
        // build notification
        let notification = UILocalNotification()
        notification.alertTitle = "Reminder"
        notification.alertBody = "Don't forget to take your \(name1!)!"
        notification.fireDate = time1
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
        guard let Name = titleField.text else {
            print("TextField text is nil")
            return }
        print (Name as Any)
        let selfDate = self.datePicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let dateString = dateFormatter.string(from: (selfDate?.date)!)
        print (dateString)
        reminderRef =  Database.database().reference().child("users")
        let reminder1 = ["Title": Name , "Time": dateString ]
        let key = reminderRef.childByAutoId().key
        reminderRef.child(userID).child("Reminders").child(key!).setValue(reminder1)
    }
    
    @IBAction func cancle(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        saveButton.layer.cornerRadius = 30
        saveButton.layer.masksToBounds = true
        
        titleField.delegate = self
        titleField.setBottomBorder();
        
        datePicker.minimumDate = NSDate() as Date
        datePicker.locale = NSLocale.current

        
        
        // Do any additional setup after loading the view.
    }
    
    func checkName() {
        // Disable the Save button if the text field is empty.
        let text = titleField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
 /*   func checkDate() {
        // Disable the Save button if date has passed
        if NSDate().earlierDate(datePicker.date) == datePicker.date {
            saveButton.isEnabled = false
        }
    }*/
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    
   
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
      //   checkDate()
    }
    

    

}
