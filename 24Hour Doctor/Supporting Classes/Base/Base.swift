//
//  Base.swift
//  Solviepro Hire
//
//  Created by mac on 28/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class Base: NSObject {
}

let appName = "24hour Doctor"

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

//user_signup.php

//let base_url = "http://itsfreehelp.com/wp-content/plugins/webservice/"

let base_url = "http://24hdr.com/doctors/webservice/"


let api_login = "\(base_url)login"

let api_signup = "\(base_url)signup"

let api_forgot_password = "\(base_url)forgot_password"

let api_category_specialist = "\(base_url)category_specialist"

let api_update_profile = "\(base_url)update_profile"

let api_get_appointment_by_date = "\(base_url)get_appointment_by_date"

let api_insert_chat = "\(base_url)insert_chat"

let api_get_chat = "\(base_url)get_chat"

let api_get_conversation = "\(base_url)get_conversation"

let api_get_profiles = "\(base_url)get_profiles"

let api_get_seduling = "\(base_url)get_seduling"

let api_seduling = "\(base_url)seduling"

let doctor_appointment = "\(base_url)doctor_appointment"

let change_password = "\(base_url)change_password"

let change_schedule_status = "\(base_url)change_schedule_status"

let get_schedule_status = "\(base_url)get_schedule_status"

let get_schedule_close = "\(base_url)get_schedule_close?"

let schedule_close = "\(base_url)schedule_close?"

let doctor_ed_ex = "\(base_url)doctor_ed_ex?"

let get_other_info = "\(base_url)get_other_info?"

let accept_appoinment = "\(base_url)accept_appoinment?"


/********************************AlertMessage*******************************/

class AlertMsg: NSObject {
  
    static let oldpass = "Please enter old password."
    static let newPas = "Please enter new password."
    static let Confirm = "Please enter confirm password."

    
    static let blankSpeciality = "Please select speciality."
    static let blankFee = "Please enter your appointment fee."
    static let blankEmail = "Please enter email address."
    static let invalidEmail = "Please enter valid email address."
    static let blankPass = "Please enter password."
    static let passLen = "Password must be at least 6 characters long."
    static let blankConfPass = "Please enter confirm password."
    static let passMissMatch = "The password and confirmation password do not match."
    
    static let blankFirstName = "Please enter first name."
    static let blankLastName = "Please enter last name."
    static let blankNumber = "Please enter mobile number."
    static let numberLen = "Number must be at least 6 characters long."
    static let blankAddress = "Please select your loation."
    static let blankQuestion = "Please select secure question."
    static let blankAnswer = "Please enter secure answer."
    static let blankDescription = "Please enter description."
    static let selectGender = "Please select gender."
    static let blankDob = "Please enter date of birth."
    static let blankMsg = "Please type a message."
    static let selectTime = "Please select time."

    
    
    
    static let strAlert = "Alert"
    static let logoutMsg = "Are you want to logout?"
    static let forgotMsg = "Please check your email for your new password it may be in your spam folder."
    static let selectDate = "Please select date."
    static let profileUpdate = "Profile updated successfully."
    static let addBusy = "Your busy schedule has been added."
    static let reject = "Your busy schedule has been added."

}

extension UIViewController {
    
    func datePickerTapped(strFormat:String,mode:UIDatePicker.Mode, completionBlock complete: @escaping (_ dateString: String) -> Void) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        var dateString:String = ""
        // let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let datePicker = DatePickerDialog(textColor: .darkGray,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("DATE",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: currentDate,
                        datePickerMode: mode) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = strFormat
                                if mode == .date {
                                    dateString = formatter.string(from: dt)
                                } else {
                                    dateString = formatter.string(from: dt)
                                }
                                complete(dateString)
                            }
        }
    }
}
