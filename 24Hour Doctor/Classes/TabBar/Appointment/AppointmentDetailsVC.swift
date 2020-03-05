//
//  AppointmentDetailsVC.swift
//  24Hour Doctor
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class AppointmentDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var view_text: View!
    @IBOutlet weak var btn_reshedule: UIButton!
    @IBOutlet weak var text_reason: UITextView!
    @IBOutlet weak var view_Attch: View!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var table_reason: UITableView!
    @IBOutlet weak var imgPatient: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var btn_attcg: UIButton!
    @IBOutlet weak var heigh_Table: NSLayoutConstraint!
    //MARK: VARIABLES
    var dictDetails = NSDictionary()
    var arrList = ["I think the patient is faked","I am busy on this time","Other"]
    var isIndex:Int! = -1
    var strReason:String! = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        text_reason.toolbarPlaceholder = "Type here"
        heigh_Table.constant = CGFloat(40 * arrList.count)
        trans_View.isHidden = true
        view_Attch.isHidden = true
        view_text.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    //MARK: ACTIONS
    @IBAction func cancel(_ sender: Any) {
        trans_View.isHidden = true
        text_reason.text = "type here..."
        isIndex = -1
        strReason = ""
    }
    @IBAction func aattach(_ sender: Any) {
        openFileAttachment()
    }
    @IBAction func done(_ sender: Any) {
        if strReason != "" {
            if strReason == "Other" {
                if text_reason.text != "type here..." {
                    wsSendReject()
                } else {
                    Http.alert(appName,AlertMsg.blankDescription)
                }
            } else {
                wsSendReject()
            }
        } else {
           Http.alert(appName,"please select reason")
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func reject(_ sender: Any) {
        trans_View.isHidden = false
    }
    @IBAction func reschedule(_ sender: Any) {
        wsAccept()
    }
    @IBAction func actionChat(_ sender: Any) {
        let dictPatient = dictDetails.object(forKey: "patient_details") as! NSDictionary
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConversationsVC") as! ConversationsVC
        vc.otherUserId = string(dictPatient, "id")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Validation

    func checkValidation() -> String? {

        if text_reason.text! == "Description (max 250 words)"{
            return AlertMsg.blankDescription
        }

        return nil
    }
    //MARK: FUNCTIONS
    func setDetails() {
        
        if string(dictDetails, "status") == "Accept" {
           btn_reshedule.isHidden = true
        }
        
        let dictPatient = dictDetails.object(forKey: "patient_details") as! NSDictionary
        imgPatient.sd_setImage(with: URL(string: string(dictPatient, "image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        lblName.text = "\(string(dictPatient, "first_name")) \(string(dictPatient, "last_name"))"
        lblAddress.text = string(dictPatient, "location")
        lblTime.text = "Appointment time: \(string(dictDetails, "time"))"
        lblDate.text = "Appointment Date: \(string(dictDetails, "date"))"
        lblDetails.text = string(dictPatient, "discription")
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
            btn_attcg.setImage(selectedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: WS_UPDATE_PROFILE
    func wsAccept() {
        
        self.view.endEditing(true)
        let params = NSMutableDictionary()
        print(dictDetails)
        params["appoinment_id"] = string(dictDetails, "id")
        params["doctor_id"] = kAppDelegate.userId
        
        Http.instance().json(accept_appoinment, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                Http.alert(appName, "Accept successfully")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }

    func wsSendReject() {
        
        self.view.endEditing(true)
        let params = NSMutableDictionary()
        print(dictDetails)
        params["schedule_id"] = string(dictDetails, "id")
        params["status"] = "Reject"
        
        if strReason == "Other" {
            params["reason"] = text_reason.text!
        } else {
            params["reason"] = strReason
        }
   
        let images = NSMutableArray()
        if profileImg != nil {
            let dict = NSMutableDictionary()
            dict["name"] = "image"
            dict["image"] = profileImg!
            images.add(dict)
        }

        Http.instance().json(change_schedule_status, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                    Http.alert(appName, "rejected successfully")
                  self.navigationController?.popToRootViewController(animated: true)
            } else {
                   Http.alert(appName, string(responce, "result"))
            }
        }
    }
}//Class End
extension AppointmentDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        
        cell.lbl_Reason.text = arrList[indexPath.row]
        
        if isIndex == indexPath.row {
            cell.img_Check.image = UIImage.init(named: "check_box")
        } else {
            cell.img_Check.image = UIImage.init(named: "uncheck_box")
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        strReason = arrList[indexPath.row]
        isIndex = indexPath.row
        table_reason.reloadData()
        
        if strReason == "Other" {
            view_Attch.isHidden = false
            view_text.isHidden = false

        } else {
            profileImg = nil
            text_reason.text = "type here..."
            view_Attch.isHidden = true
            view_text.isHidden = true
        }
    }
}
extension AppointmentDetailsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == text_reason {
            if text_reason.textColor == UIColor.lightText {
                text_reason.textColor = UIColor.white
                text_reason.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text_reason.text.isEmpty {
            text_reason.text = "type here..."
            text_reason.textColor = UIColor.lightText
        }
    }
}
