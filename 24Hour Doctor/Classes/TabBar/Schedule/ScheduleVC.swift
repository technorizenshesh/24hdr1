//
//  ScheduleVC.swift
//  24Hour Doctor
//
//  Created by mac on 24/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import FSCalendar
class timeCollectioCell:UICollectionViewCell {

    @IBOutlet weak var lbl_Time: UILabel!
}
class ScheduleVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var vwCalender: FSCalendar!
    @IBOutlet var view_CloseDay: UIView!
    @IBOutlet weak var collection_Time: UICollectionView!
    
    
    var isSlectTime:Int! = -1
    var arrScheduled = [String]()
    var arrBookedTime = [String]()
    var isDayFalse:String! = "false"
    var strdate:String! = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view_CloseDay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view_CloseDay.frame = self.view.frame
        arrScheduled = setTimeArray()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        print(arrScheduled.count)
        
    }
    
    //MARK:GetTimeSlot
    func setTimeArray() -> [String] {
        var array: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm a"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "hh:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dt = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dt)
        let Curdate = dt.toString(dateFormat: "dd-MM-yyyy")
        let Nxtdate = tomorrow!.toString(dateFormat: "dd-MM-yyyy")
        let startDate = "\(Curdate) 00:00"
        let endDate = "\(Nxtdate) 12:00"
        
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        let interval = 20
        let interval2 = 40
        
        let string = formatter3.string(from: date1!)
        let dateF = date1!.addingTimeInterval(TimeInterval(interval*60))
        let stringF = formatter2.string(from: dateF)
        array.append("\(string)-\(stringF)")
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*interval*60))
            let date23 = date?.addingTimeInterval(TimeInterval(interval*60))
            
            let string = formatter3.string(from: date!)
            let stringAM = formatter2.string(from: date23!)
            
            if date! >= date2! {
                break;
            }
            
            i += 1
            if !array.contains("\(string)-\(stringAM)") {
                array.append("\(string)-\(stringAM)")
            }
        }
        return array
    }
    // MARK: - Navigation

    @IBAction func sidemenu(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func swoitch(_ sender: UISwitch) {
        if sender.isOn {
           sender.isOn = false
           isDayFalse = "false"
           arrBookedTime = []
        } else {
           sender.isOn = true
           isDayFalse = "true"
           arrBookedTime = []
           arrBookedTime = arrScheduled
        }
        collection_Time.reloadData()
    }
    
    @IBAction func cacnel(_ sender: Any) {
        self.view_CloseDay.removeFromSuperview()
    }
    @IBAction func Submit(_ sender: Any) {
        if arrBookedTime.count != 0 {
            wsAddScheduling(arrBookedTime.joined(separator: ","))
        } else {
            self.view_CloseDay.removeFromSuperview()
        }
    }
    
    //MARK: UICOLLECTION VIEW DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrScheduled.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeCell
        //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
        cell.lblTime.layer.cornerRadius = 5
        cell.lblTime.layer.borderWidth = 1
//        cell.lblTime.layer.borderColor = Http.hexStringToUIColor("#289CA0").cgColor
        cell.lblTime.clipsToBounds = true
        
        if arrBookedTime.contains(arrScheduled[indexPath.row]) {
            cell.lblTime.backgroundColor = Http.hexStringToUIColor("#289CA0")
            cell.lblTime.textColor = UIColor.white
        } else {
            cell.lblTime.backgroundColor = UIColor.white
            cell.lblTime.textColor = Http.hexStringToUIColor("#289CA0")
        }
        cell.lblTime.text = arrScheduled[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
        arrBookedTime.append(arrScheduled[indexPath.row])
        collection_Time.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (PredefinedConstants.ScreenWidth - 56) / 3
        return CGSize(width: width, height: 60)
    }
    //MARK:API
    func wsGetScheduling(_ strDate: String) {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        params["close_date"] = strDate
        let images = NSMutableArray()
        
        Http.instance().json(get_schedule_close, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                self.arrBookedTime  = []
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    if let close_timef = result.object(forKey: "close_time") as? String {
                        self.arrBookedTime = close_timef.components(separatedBy: ",")
                    }
                }
                self.view.addSubview(self.view_CloseDay)
                self.collection_Time.reloadData()
            }
        }
    }
    func wsAddScheduling(_ str_Time: String) {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        params["close_date"] = self.strdate
        params["close_time"] = str_Time
        params["full_day_status"] = isDayFalse

        let images = NSMutableArray()
        
        Http.instance().json(schedule_close, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                self.view_CloseDay.removeFromSuperview()
            }
        }
    }
}
extension ScheduleVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: date)
        self.strdate = strDate
        wsGetScheduling(strDate)
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
        
//        if (arrAppointmentDates.contains(formatter.string(from: date))) {
//            return UIColor.red
//        } else if (arrCloseDates.contains(formatter.string(from: date)))  {
//            return UIColor.lightGray
//        } else {
//            return UIColor.black
//        }
         return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
//        if (arrCloseDates.contains(formatter.string(from: date))) {
//            return false
//        }
//        else {
//            return true
//        }
                    return true

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

