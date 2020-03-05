//
//  ProfileVC.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown
import CoreLocation

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,LFTimePickerDelegate {
    
    @IBOutlet weak var textemail: UITextField!
    //MARK: OUTLETS
    @IBOutlet weak var btnProfile: Button!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfAppointmentFee: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet var tebl_Hour: UITableView!
    
    //Opening_Hour
    var strALlDay:String! = ""
    var strStartTime:String! = ""
    var strEndTime:String! = ""
    var stropeningStatus:String! = ""
    var strFullDay:String! = ""
    let timePicker = LFTimePickerController()
    
    //MARK: VARIABLES
    var dropDown = DropDown()
    var dtPkr = UIDatePicker()
    var lat = 0.0
    var lon = 0.0
    var strIsBack:String! = ""
    var arr_AllDay:NSArray! = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    var arr_AllTime:NSMutableArray! = [["fullday_open_status":"","STATUS":"CLOSE","DAY":"Sunday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Monday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Tuesday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Wednesday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Thursday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Friday","START_TIME":"0.0","END_TIME":"0.0"],["fullday_open_status":"","STATUS":"CLOSE","DAY":"Saturday","START_TIME":"0.0","END_TIME":"0.0"]]
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        timePicker.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(getAddress(notification:)), name: NSNotification.Name("address"), object: nil)
        
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    
    @IBAction func AdditionlaInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalInfoVC") as! AdditionalInfoVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func actionHome(_ sender: Any) {
        if strIsBack == "" {
            self.sideMenuViewController.presentLeftMenuViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
//        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
        } else {
            GetAll_DayAreNot()
            wsUpdateProfile()
        }
    }
    
    @IBAction func imgProfile(_ sender: Any) {
            openFileAttachment()
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
    
    func setDetails() {
        lblName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
        btnProfile.sd_setImage(with: URL(string: string(kAppDelegate.userInfo, "image")), for: .normal, placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        lat = Double(truncating: number(kAppDelegate.userInfo, "lat"))
        lon = Double(truncating: number(kAppDelegate.userInfo, "lon"))
        tfFirstName.text = string(kAppDelegate.userInfo, "first_name")
        tfLastName.text = string(kAppDelegate.userInfo, "last_name")
        textemail.text = string(kAppDelegate.userInfo, "email")

//        tfGender.text = string(kAppDelegate.userInfo, "gender")
        tfAppointmentFee.text = string(kAppDelegate.userInfo, "appointment_fee")
//        tfDOB.text = string(kAppDelegate.userInfo, "dob")
        tfNumber.text = string(kAppDelegate.userInfo, "mobile")
        tfLocation.text = string(kAppDelegate.userInfo, "location")
        
        print(kAppDelegate.userInfo)
        
    if string(kAppDelegate.userInfo, "days").components(separatedBy: ",").count > 1 {
            
        for i in 0..<arr_AllDay.count {
            let day_Name = string(kAppDelegate.userInfo, "days").components(separatedBy: ",")
            let start = string(kAppDelegate.userInfo, "start_time").components(separatedBy: ",")
            let end = string(kAppDelegate.userInfo, "end_time").components(separatedBy: ",")
            let status = string(kAppDelegate.userInfo, "status_day").components(separatedBy: ",")
//            let FullDay = dic["fullday_open_status"] as! String
            
            print(start)
            print(end)
            print(status)

            if arr_AllDay.contains(day_Name[i]) {
                let index = arr_AllDay.index(of: day_Name[i])
                let dic = ["fullday_open_status":"FUllday","START_TIME":start[i],"END_TIME":end[i],"DAY":day_Name[i],"STATUS":status[i]] as [String : Any]
                arr_AllTime.replaceObject(at: index, with: dic)
            }
        }
        tebl_Hour.reloadData()
    }
//        tvDescription.text = string(kAppDelegate.userInfo, "discription")
//        let description = string(kAppDelegate.userInfo, "discription")
//        if description == "" {
//            tvDescription.text = "Description (max 250 words)"
//            tvDescription.textColor = UIColor.darkGray
//        } else {
//            tvDescription.text = description
//            tvDescription.textColor = UIColor.black
//        }
        
//        dropDown.dataSource = ["Male", "Female", "Other"]
//        dropDown.anchorView = tfGender
//        dropDown.selectionAction = {[unowned self] (index, item) in
//            self.tfGender.text = item
//        }
        
//        dtPkr.maximumDate = Date()
//        dtPkr.datePickerMode = .date
//        tfDOB.inputView = dtPkr
    }
    
    func checkValidation() -> String? {
        if tfFirstName.text?.count == 0 {
            return AlertMsg.blankFirstName
        } else if tfLastName.text?.count == 0 {
            return AlertMsg.blankLastName
        } else if tfLastName.text?.count == 0 {
            return AlertMsg.blankLastName
        } 
//        else if tvDescription.text! == "Description (max 250 words)"{
//            return AlertMsg.blankDescription
//        }
        else if tfAppointmentFee.text?.count == 0 {
            return AlertMsg.blankFee
        }
//        else if tfGender.text?.count == 0 {
//            return AlertMsg.selectGender
//        } else if tfDOB.text?.count == 0 {
//            return AlertMsg.blankDob
//        }
        else if tfNumber.text?.count == 0 {
            return AlertMsg.blankNumber
        } else if tfNumber.text!.count < 6 {
            return AlertMsg.numberLen
        } else if tfLocation.text?.count == 0 {
            return AlertMsg.blankAddress
        }
        return nil
    }
    
    func openFileAttachment() {
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: PICKERVIEW DELEGATE
    var profileImg: UIImage? = nil
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if selectedImage != nil {
            profileImg = selectedImage
            btnProfile.setImage(selectedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: WS_UPDATE_PROFILE
    func wsUpdateProfile() {
        self.view.endEditing(true)
        
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["user_type"] = kAppDelegate.userType
        params["speciality"] = string(kAppDelegate.userInfo, "speciality")
        params["email"] = string(kAppDelegate.userInfo, "email")
//        params["gender"] = tfGender.text!
        params["appointment_fee"] = tfAppointmentFee.text!
        params["mobile"] = tfNumber.text!
        params["first_name"] = tfFirstName.text!
        params["last_name"] = tfLastName.text!
        params["location"] = tfLocation.text!
        params["lat"] = "\(lat)"
        params["lon"] = "\(lon)"
        params["start_time"] = strStartTime!
        params["end_time"] = strEndTime!
        params["status_day"] = stropeningStatus!
        params["days"] = strALlDay!
        
//        params["dob"] = tfDOB.text!
//        params["discription"] = tvDescription.text!
        
        let images = NSMutableArray()
        if profileImg != nil {
            let dict = NSMutableDictionary()
            dict["name"] = "image"
            dict["image"] = profileImg!
            images.add(dict)
        }
        
        Http.instance().json(api_update_profile, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    kAppDelegate.saveUser(result)
                    Http.alert(appName, AlertMsg.profileUpdate)
                    self.lblName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
                }
            } else {
                Http.alert(appName, string(responce, "result"))
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

extension ProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == tvDescription {
            if tvDescription.textColor == UIColor.darkGray {
                tvDescription.textColor = UIColor.black
                tvDescription.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescription.text.isEmpty {
            tvDescription.text = "Description (max 250 words)"
            tvDescription.textColor = UIColor.darkGray
        }
    }
}


extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfGender {
            dropDown.show()
            return false
        } else if textField == tfLocation {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickAddressVC") as! PickAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkDob(tf: textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkDob(tf: textField)
        return true
    }
    
    func checkDob(tf: UITextField)  {
        if tf == tfDOB {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            tfDOB.text = formatter.string(from: dtPkr.date)
        }
    }
    
}

