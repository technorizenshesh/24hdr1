//
//  HomeVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Koyomi
import SDWebImage
import FSCalendar

class HomeVC: UIViewController, KoyomiDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: OUTLETS
    @IBOutlet weak var height_Table: NSLayoutConstraint!
    @IBOutlet weak var table_Appointment: UITableView!
    @IBOutlet weak var vwCalender: FSCalendar!
    @IBOutlet var vwDaysPopUp: UIView!
    @IBOutlet weak var cvDays: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!

    //doctor_appointment
    //MARK: VARIABLES
    var strDate = ""
    var strTime = ""
    var arrDays = ["12:01 PM", "01:02 PM", "02:03 PM", "03:04 PM", "04:05 PM", "05:06 PM", "06:07 PM", "07:08 PM", "08:09 PM", "09:10 PM"]
    var arrTimes = NSMutableArray()
    var arrScheduled = [String]()
    var arrList = NSArray()
    var arrCloseDates = NSArray()
    var arrAppointmentDates = NSArray()

    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        vwDaysPopUp.frame = self.view.frame
        table_Appointment.isHidden = true
        self.vwCalender.delegate = self
        self.vwCalender.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        wsGetAllApointment()
        wsGetSchedulingDate()

    }
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func actionSchedule(_ sender: Any) {
        if strDate == "" {
            Http.alert(AlertMsg.strAlert, AlertMsg.selectDate)
        } else {
            wsGetScheduling(strDate)
        }
    }
    
    @IBAction func actionRemoveDays(_ sender: Any) {
        vwDaysPopUp.removeFromSuperview()
    }
    
    @IBAction func actionSubmitDay(_ sender: Any) {
        if strTime == "" {
            Http.alert(appName, AlertMsg.selectTime)
        } else {
            wsScheduleTime()
        }
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if strDate == "" {
            Http.alert(appName, AlertMsg.selectDate)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentListVC") as! AppointmentListVC
            vc.strDate = self.strDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //MARK: FUNCTIONS
    func createArray() {
        arrTimes.removeAllObjects()
        for strTime1 in arrDays {
            var isAdded = false
            
            for strTime2 in arrScheduled {
                if strTime1 == strTime2 {
                    isAdded = true
                }
            }
            if !isAdded {
                arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            } else {
                arrTimes.add(["time": strTime1, "schedule": "1", "select": "0"])
            }
        }
        self.cvDays.reloadData()
        //kAppDelegate.window?.addSubview(vwDaysPopUp)
        self.view.addSubview(vwDaysPopUp)
    }
    
    /*
     func checkValidations() -> String? {
     
     if tfDate.text?.count == 0 {
     return AlertMsg.selectBookDate
     } else if tfTime.text?.count == 0 {
     return AlertMsg.selectBookTime
     }
     return nil
     }
     */
    
    //MARK: KOYOMI DELEGATE
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: date!)
        self.strDate = strDate
    }
    
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        
        let selectDate = date!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components1 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectDate)
        let components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        
        if components1.day! < components2.day! && components1.day! < components2.day! {
            Http.alert(appName, "You can't select past date.")
            return false
        }
        
        return true
    }
    
    //MARK: UICOLLECTION VIEW DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
        //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
        cell.lblTime.layer.cornerRadius = 5
        cell.lblTime.layer.borderWidth = 1
        cell.lblTime.layer.borderColor = PredefinedConstants.appColor().cgColor
        cell.lblTime.clipsToBounds = true
        
        let dict = arrTimes.object(at: indexPath.row) as! NSDictionary
        print("dict-\(dict)-")
        if string(dict, "schedule") == "1" {
            cell.lblTime.backgroundColor = UIColor.darkGray
            cell.lblTime.textColor = UIColor.white
        } else if string(dict, "select") == "1" {
            cell.lblTime.backgroundColor = PredefinedConstants.appColor()
            cell.lblTime.textColor = UIColor.white
        } else {
            cell.lblTime.backgroundColor = UIColor.white
            cell.lblTime.textColor = PredefinedConstants.appColor()
        }
        cell.lblTime.text = string(dict, "time")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvDays {
            //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            var mdict = NSMutableDictionary()
            
            for i in 0..<arrTimes.count {
                mdict = (arrTimes.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if string(mdict, "schedule") == "0" {
                    if indexPath.row == i {
                        mdict["select"] = "1"
                        strTime = string(mdict, "time")
                        //tfTime.text = string(mdict, "time")
                        //vwDaysPopUp.removeFromSuperview()
                    } else {
                        mdict["select"] = "0"
                    }
                    arrTimes.replaceObject(at: i, with: mdict)
                }
            }
            cvDays.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = PredefinedConstants.ScreenWidth/2
        
        let width = (PredefinedConstants.ScreenWidth - 96) / 3
        return CGSize(width: width, height: 50)
        
    }
    
    //MARK: WS_GET_SCHEDULING
    func  wsGetScheduling(_ strDate: String) {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        params["date"] = strDate

        Http.instance().json(api_get_seduling, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? [String] {
                    self.arrScheduled = result
                }
            }}
            self.createArray()
        
    }
    
    //MARK: WS_SCHEDULE_TIME
    func wsScheduleTime() {
        
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = kAppDelegate.userId
        params["date"] = strDate
        params["time"] = strTime
        params["immediate"] = "no"
        
        Http.instance().json(api_seduling, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                Http.alert("", AlertMsg.addBusy, [self, "Ok"])
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    override func alertZero() {
        vwDaysPopUp.removeFromSuperview()
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: WS_GET_APPOINTMENT_BY_DATE
    func wsGetAppointmentbydate(strDate: String) {
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        params["date"] = strDate
        
        Http.instance().json(api_get_appointment_by_date, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.lblNoData.isHidden = true
                    self.arrList = result
                    self.height_Table.constant = CGFloat(125*self.arrList.count)
                    self.table_Appointment.isHidden = false
                    self.table_Appointment.reloadData()
                }
            } else {
                self.table_Appointment.isHidden = true
                self.lblNoData.isHidden = false
                //Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsGetAllApointment() {
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        Http.instance().json(doctor_appointment, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrAppointmentDates = result.map({($0 as! NSDictionary).value(forKey: "date")}) as NSArray
                }
            }
        }
    }
    func wsGetSchedulingDate() {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        let images = NSMutableArray()
        Http.instance().json(get_schedule_status, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrCloseDates = result.map({($0 as! NSDictionary).value(forKey: "close_date")}) as NSArray
                    print(self.arrCloseDates)
                }
            } else {
                self.arrCloseDates  = []
            }
        }
    }
}//Class End

class TimeCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwBG: UIView!
    
}
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        let dictPatient = dict.object(forKey: "patient_details") as! NSDictionary
        cell.imgBg.sd_setImage(with: URL(string: string(dictPatient, "image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
//        cell.lblName.text = "\(string(dictPatient, "first_name")) \(string(dictPatient, "last_name"))"
        cell.lblName.text = "\(string(dictPatient, "date"))"

        cell.lblTime.text = string(dict, "time")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailsVC") as! AppointmentDetailsVC
        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: date)
        self.strDate = strDate
        wsGetAppointmentbydate(strDate: self.strDate)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // arrDates = self.getUserSelectedDates(arr_CurrentDay, calender: self.vwCalender)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        if (arrAppointmentDates.contains(formatter.string(from: date))) {
            return UIColor.red
        } else if (arrCloseDates.contains(formatter.string(from: date)))  {
            return UIColor.lightGray
        } else {
            return UIColor.black
        }
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if (arrCloseDates.contains(formatter.string(from: date))) {
            return false
        }
        else {
            return true
        }
    }
    
    func convertNextDate(dateString : String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(somedateString)")
    }
    
    
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
