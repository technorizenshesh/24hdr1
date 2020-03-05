//
//  AppointmentListVC.swift
//  24Hour Doctor
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class AppointmentListVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    //MARK: VARIABLES
    var strDate = ""
    var arrList = NSArray()
    
    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
         wsGetAppointment()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        if strDate == "" {
            self.sideMenuViewController.presentLeftMenuViewController()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    //MARK: FUNCTIONS
    
    
    //MARK: WS_GET_APPOINTMENT_BY_DATE
    func wsGetAppointment() {
        //http://24hdr.com/doctors/webservice/doctor_appointment?doctor_id=37
        //http://24hdr.com/doctors/webservice/get_appointment_by_date?doctor_id=5&date=22/05/2019
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        var strApi:String = ""
        if strDate == "" {
            strApi = doctor_appointment
        } else {
            strApi = api_get_appointment_by_date
        }
        params["date"] = strDate
        
        Http.instance().json(strApi, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.lblNoData.isHidden = true
                    self.arrList = result
                    self.tblView.reloadData()
                }
            } else {
                self.lblNoData.isHidden = false
                //Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End

extension AppointmentListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return strDate
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
      
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        let dictPatient = dict.object(forKey: "patient_details") as! NSDictionary
        cell.imgBg.sd_setImage(with: URL(string: string(dictPatient, "image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dictPatient, "first_name")) \(string(dictPatient, "last_name"))"
        cell.lblTime.text = "\(string(dict, "date"))\n\(string(dict, "time"))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailsVC") as! AppointmentDetailsVC
        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
