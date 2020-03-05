//
//  SignUpVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation

class SignUpVC: UIViewController,UITableViewDelegate,UITableViewDataSource,LFTimePickerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var tfSpeciality: UITextField!
    @IBOutlet weak var tfAppointmentFee: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var tfQuestion: UITextField!
    @IBOutlet weak var tfAnswer: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet var tebl_Hour: UITableView!
    
    //Opening_Hour
    var strALlDay:String! = ""
    var strStartTime:String! = ""
    var strEndTime:String! = ""
    var stropeningStatus:String! = ""
    var strFullDay:String! = ""
    let timePicker = LFTimePickerController()

    //MARK: VARIABLES
    var arrQuestions = ["What was your childhood nickname?", "What was your favorite sport?", "What is your pet's name?", "What is your favorite color?"]
    var dropDown = DropDown()
    var dropSpeciality = DropDown()
    var arrSpeciality = NSArray()
    var specialityId = ""
    var lat = 0.0
    var lon = 0.0
    
    var arr_AllDay:NSArray! = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    var arr_AllTime:NSMutableArray! = [["fullday_open_status":"","STATUS":"CLOSE","DAY":"Sunday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Monday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Tuesday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Wednesday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Thursday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Friday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Saturday","START_TIME":"0.0","END_TIME":"0.0"]]
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        setDropDown()
        wsGetSpeciality()
        NotificationCenter.default.addObserver(self, selector: #selector(getAddress(notification:)), name: NSNotification.Name("address"), object: nil)
    }
    
    func setDropDown() {
        tfQuestion.delegate = self
        dropDown.dataSource = arrQuestions
        dropDown.anchorView = tfQuestion
        dropDown.selectionAction = {[unowned self] (index, item) in
            self.tfQuestion.text = item
        }
        tfSpeciality.delegate = self
        dropSpeciality.anchorView = tfSpeciality
        dropSpeciality.selectionAction = {[unowned self] (index, item) in
            self.tfSpeciality.text = item
            if index < self.arrSpeciality.count {
                let dict = self.arrSpeciality.object(at: index) as! NSDictionary
                self.specialityId = string(dict, "id")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
            
        } else {
            GetAll_DayAreNot()
            wsSignUp()
        }
    }
    
    var isAccept = true
    
    @IBAction func actionPrivacy(_ sender: Any) {
        isAccept = !isAccept
        if isAccept {
            btnCheck.setImage(UIImage(named: "check_box"), for: .normal)
        } else {
            btnCheck.setImage(UIImage(named: "uncheck_box"), for: .normal)
        }
    }
    
    @IBAction func tfLogin(_ sender: Any) {
    }
    
    //MARK: FUNCTIONS
    @objc func getAddress(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            tfLocation.text = string(dict, "address")
            if let coords = dict.object(forKey: "coordinate") as? CLLocation {
                lat = coords.coordinate.latitude
                lon = coords.coordinate.longitude
            }
        }
    }
    
    func checkValidation() -> String? {
        if tfSpeciality.text?.count == 0 {
            return AlertMsg.blankSpeciality
        } else if tfAppointmentFee.text?.count == 0 {
            return AlertMsg.blankFee
        } else if tfEmail.text?.count == 0 {
            return AlertMsg.blankEmail
        } else if !(tfEmail.text!.isEmail) {
            return AlertMsg.invalidEmail
        } else if tfNumber.text?.count == 0 {
            return AlertMsg.blankNumber
        } else if tfNumber.text!.count < 6 {
            return AlertMsg.numberLen
        } else if tfPassword.text?.count == 0 {
            return AlertMsg.blankPass
        } else if tfPassword.text!.count < 6 {
            return AlertMsg.numberLen
        }  else if tfConfirmPassword.text?.count == 0 {
            return AlertMsg.blankConfPass
        }  else if tfPassword.text! != tfConfirmPassword.text! {
            return AlertMsg.passMissMatch
        } else if tfFirstName.text?.count == 0 {
            return AlertMsg.blankFirstName
        } else if tfLastName.text?.count == 0 {
            return AlertMsg.blankLastName
        } else if tfLocation.text?.count == 0 {
            return AlertMsg.blankAddress
        } else if tfQuestion.text?.count == 0 {
            return AlertMsg.blankQuestion
        } else if tfAnswer.text?.count == 0 {
            return AlertMsg.blankAnswer
        }
        return nil
    }
    
    //MARK: WS_GET_SPECIALITY
    func wsGetSpeciality() {
        
        let params = NSMutableDictionary()
        
        Http.instance().json(api_category_specialist, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrSpeciality = result
                    for i in 0..<result.count {
                        let dict = result.object(at: i) as! NSDictionary
                        self.dropSpeciality.dataSource.append(string(dict, "category_name"))
                    }
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    //MARK: WS_SIGNUP
    func wsSignUp() {

        let params = NSMutableDictionary()
        params["user_type"] = kAppDelegate.userType
        params["speciality"] = specialityId
        params["appointment_fee"] = tfAppointmentFee.text!
        params["email"] = tfEmail.text!
        params["password"] = tfPassword.text!
        params["mobile"] = tfNumber.text!
        params["first_name"] = tfFirstName.text!
        params["last_name"] = tfLastName.text!
        params["location"] = tfLocation.text!
        params["security_que"] = tfQuestion.text!
        params["security_ans"] = tfAnswer.text!
        params["lat"] = "\(lat)"
        params["lon"] = "\(lon)"
        params["ios_register_id"] = kAppDelegate.token
        params["start_time"] = strStartTime!
        params["end_time"] = strEndTime!
        params["status_day"] = stropeningStatus!
        params["days"] = strALlDay!
        params["register_id"] = ""

        Http.instance().json(api_signup, params, true, nil, self.view) { (responce) in

            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    kAppDelegate.saveUser(result)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
                    kAppDelegate.window?.rootViewController = vc
                }
            } else {
                Http.alert(appName, string(responce, "message"))
            }
        }
    }
    
    //MARK: Tableview Time Picker
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_AllTime.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.lbl_Day.text = (arr_AllDay[indexPath.row] as! String)
        let dic_Indo = self.arr_AllTime.object(at: indexPath.row) as! NSDictionary
        
        if let str_Start = dic_Indo["START_TIME"]! as? String {
            cell.text_Start_Time.text = str_Start
        }
        if let str_End = dic_Indo["END_TIME"]! as? String {
            cell.text_Ent_Time.text = str_End
        }
        
//        let FullDayt = dic_Indo["fullday_open_status"]! as? String
//        
//        if FullDayt == "" || FullDayt == "DEFAULT" {
//            cell.btn_24.backgroundColor = UIColor.darkGray
//            
//        } else {
//            cell.btn_24.backgroundColor =  UIColor.init(named: "App Color")
//        }
        
        let STATUS = dic_Indo["STATUS"]! as? String
        
        if STATUS == "" || STATUS == "CLOSE" {
            cell.btn_OpenClose.setTitle("Closed", for: .normal)
            cell.btn_OpenClose.backgroundColor = UIColor.darkGray
        }
        else {
            cell.btn_OpenClose.setTitle("Open", for: .normal)
            cell.btn_OpenClose.backgroundColor = UIColor.init(named: "App Color")
        }
        cell.btn_On_StartAndEnd.tag = indexPath.row
        cell.btn_On_StartAndEnd.addTarget(self, action: #selector(click_on_SartTime), for: .touchUpInside)
        
        cell.btn_OpenClose.tag = indexPath.row
        cell.btn_OpenClose.addTarget(self, action: #selector(click_on_OpenOrlose), for: .touchUpInside)
        
//        cell.btn_24.tag = indexPath.row
//        cell.btn_24.addTarget(self, action: #selector(click_on_24Hour), for: .touchUpInside)
        
        return cell
    }
    @objc func click_on_OpenOrlose(textTag:UIButton)  {
        let dic_Indo = self.arr_AllTime.object(at: textTag.tag) as! NSDictionary
        let newDic:NSMutableDictionary! = [:]
        newDic.addEntries(from: (dic_Indo ) as! [AnyHashable : Any])
        if dic_Indo["STATUS"] as! String == "" || dic_Indo["STATUS"] as! String == "CLOSE" {
            newDic.setObject("OPEN", forKey: "STATUS" as NSCopying)
        }
        else {
            newDic.setObject("CLOSE", forKey: "STATUS" as NSCopying)
        }
        self.arr_AllTime.replaceObject(at: textTag.tag, with: newDic)
        tebl_Hour.reloadData()
        
    }
//    @objc func click_on_24Hour(textTag:UIButton)  {
//        let dic_Indo = self.arr_AllTime.object(at: textTag.tag) as! NSDictionary
//        let newDic:NSMutableDictionary! = [:]
//        newDic.addEntries(from: (dic_Indo ) as! [AnyHashable : Any])
//        if dic_Indo["fullday_open_status"] as! String == "" || dic_Indo["fullday_open_status"] as! String == "DEFAULT" {
//            newDic.setObject("OPEN", forKey: "fullday_open_status" as NSCopying)
//        }
//        else {
//            newDic.setObject("DEFAULT", forKey: "fullday_open_status" as NSCopying)
//        }
//        self.arr_AllTime.replaceObject(at: textTag.tag, with: newDic)
//        tebl_Hour.reloadData()
//    }
    @objc func click_on_SartTime(textTag:UIButton)  {
        timePicker.timeType = .hour24
        timePicker.strDay = (arr_AllDay[textTag.tag] as! String)
        let dic_Indo = self.arr_AllTime.object(at: textTag.tag) as! NSDictionary
        timePicker.strOpenStatus = (dic_Indo["STATUS"] as! String)
        self.navigationController?.pushViewController(timePicker, animated: false)
    }
    func didPickTime(_ start: String, end: String, day: String,statsu: String) {
        
        print(start)
        print(end)
        print(day)
        print(statsu)
        
        let dic = ["fullday_open_status":"DEFAULT","STATUS":statsu,"START_TIME":start,"END_TIME":end,"DAY":day]
        let index = arr_AllDay.index(of: day)
        arr_AllTime.replaceObject(at: index, with: dic)
        tebl_Hour.reloadData()
        
    }
    func GetAll_DayAreNot()  {
        
//  24
//  var STATUSFull:NSMutableArray! = []
//  let STATUS12 = arr_AllTime.value(forKey: "fullday_open_status") as! NSArray
//  STATUSFull = STATUS12.mutableCopy() as! NSMutableArray
//  STATUSFull.removeObjects(in: [""])
//  StrFullDay = STATUSFull.componentsJoined(by: ",")
//  Print(strFullDay)

        //Status
        var STATUS:NSMutableArray! = []
        let STATUS1 = arr_AllTime.value(forKey: "STATUS") as! NSArray
        STATUS = (STATUS1.mutableCopy() as! NSMutableArray)
        STATUS.removeObjects(in: [""])
        stropeningStatus = STATUS.componentsJoined(by: ",")
        
        //DAY
        var arr_Day1:NSMutableArray! = []
        let arr_Day = arr_AllTime.value(forKey: "DAY") as! NSArray
        arr_Day1 = (arr_Day.mutableCopy() as! NSMutableArray)
        arr_Day1.removeObjects(in: [""])
        strALlDay = arr_Day1.componentsJoined(by: ",")
        
        //STAERT
        var arr_Start1:NSMutableArray! = []
        let start = arr_AllTime.value(forKey: "START_TIME") as! NSArray
        arr_Start1 = (start.mutableCopy() as! NSMutableArray)
        arr_Start1.removeObjects(in: [""])
        strStartTime = arr_Start1.componentsJoined(by: ",")
        
        //END
        var END_TIME1:NSMutableArray! = []
        let END_TIME = arr_AllTime.value(forKey: "END_TIME") as! NSArray
        END_TIME1 = (END_TIME.mutableCopy() as! NSMutableArray)
        END_TIME1.removeObjects(in: [""])
        strEndTime = END_TIME1.componentsJoined(by: ",")
        
    }
}//Class End

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfSpeciality {
            dropSpeciality.show()
            return false
        } else if textField == tfLocation {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickAddressVC") as! PickAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        } else if textField == tfQuestion {
            dropDown.show()
            return false
        }
        return true
    }
}
