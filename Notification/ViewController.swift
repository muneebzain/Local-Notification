//
//  ViewController.swift
//  Notification
//
//  Created by Muneeb Zain on 28/03/2022.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var year: Int?
    var day: Int?
    var month: Int?
    var hour: Int?
    var minute: Int?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        requestAuthForLocalNotifications()
        
        
    }
    
    
    @IBAction func dateTxtFieldPressed(_ sender: UITextField) {
        self.datePicker()
    }
    
    
    @IBAction func timeTxtFieldPressed(_ sender: UITextField) {
        self.timePicker()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - For Date
    func datePicker() {
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        dateTxtField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClicked))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClicked))
        
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: true)
        dateTxtField.inputAccessoryView = toolbar
      
        
        
    }
    
    
    @objc func doneBtnClicked() {
        
        if let datePicker = dateTxtField.inputView as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateTxtField.text = dateFormatter.string(from: datePicker.date)
            let components = datePicker.calendar.dateComponents([.month,.day,.year], from: datePicker.date)
            
            year = components.year
            day = components.day
            month = components.month
            scheduleLocalNotification()


        }
        
        dateTxtField.resignFirstResponder()
    }
    
    @objc func cancelBtnClicked() {
        
        dateTxtField.resignFirstResponder()
        
    }
    
    
    //MARK: - For Time
    func timePicker() {
        let datePicker = UIDatePicker()

        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        timeTxtField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.done))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: true)
        timeTxtField.inputAccessoryView = toolbar
        
    }
    
    
    @objc func done() {
        
        if let datePicker = timeTxtField.inputView as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            timeTxtField.text = dateFormatter.string(from: datePicker.date)
            let timeComponents = datePicker.calendar.dateComponents([.hour,.minute], from: datePicker.date)
            
            self.hour = timeComponents.hour
            self.minute = timeComponents.minute
            scheduleLocalNotification()

            

        }
        
        timeTxtField.resignFirstResponder()
    }
    
    @objc func cancel() {
        
        timeTxtField.resignFirstResponder()
        
    }
    
    func requestAuthForLocalNotifications(){
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notification")
            }
        }
    }
    
    func scheduleLocalNotification(){
        //checking the notification setting whether it's authorized or not to send a request.
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                
                //1. create contents
                let content = UNMutableNotificationContent()
                content.title = "Complete your todo"
                content.body = "Kesa diya phir"
                content.sound = UNNotificationSound.default
                // Set the date here when you want Notification

                let calendar = Calendar.current
                let components = DateComponents(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: self.minute)
                let date = calendar.date(from: components)
                let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date!)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: false)
                
                //3. make a request
                let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if error != nil{
                        print("error in notification! ")
                    }
                }
            }
            else {
                print("user denied")
            }
        }
    }
}


