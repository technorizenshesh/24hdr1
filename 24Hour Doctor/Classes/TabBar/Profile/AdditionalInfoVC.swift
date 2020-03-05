//
//  AdditionalInfoVC.swift
//  24Hour Doctor
//
//  Created by mac on 27/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ExperinceCell: UITableViewCell {
    @IBOutlet weak var text_ExStart: UITextField!
    @IBOutlet weak var btn_Exper: UIButton!
    @IBOutlet weak var text_Experience: UITextField!
    @IBOutlet weak var text_ExEnd: UITextField!
}
class EducationCell: UITableViewCell {
    @IBOutlet weak var btn_Educat: UIButton!
    @IBOutlet weak var text_Education: UITextField!
    @IBOutlet weak var text_PassoutDate: UITextField!
}

class AdditionalInfoVC: UIViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {

    var arr_Exper:NSMutableArray = []
    var arr_Education:NSMutableArray = []

    @IBOutlet weak var text_Other: UITextField!
    @IBOutlet weak var table_Height: NSLayoutConstraint!
    @IBOutlet weak var table_Expe: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetProfile()
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func Save(_ sender: Any) {
        print(arr_Exper)
        print(arr_Education)

    }
    
    //MARK: WS_UPDATE_PROFILE
    func wsGetProfile() {
        self.view.endEditing(true)
        
        let params = NSMutableDictionary()
        params["doctor_id"] = kAppDelegate.userId
        let images = NSMutableArray()

        Http.instance().json(get_other_info, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let arr = responce["experience"] as? NSArray {
                    self.arr_Exper = arr.mutableCopy() as! NSMutableArray
                }
                if let arr = responce["education"] as? NSArray {
                    self.arr_Education = arr.mutableCopy() as! NSMutableArray
                }
                let cou = self.arr_Education.count+self.arr_Exper.count
                self.table_Height.constant = CGFloat(166*cou)
                self.table_Expe.reloadData()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsUpdateProfile() {
           self.view.endEditing(true)
           
           let params = NSMutableDictionary()
           params["doctor_id"] = kAppDelegate.userId
           let images = NSMutableArray()

           Http.instance().json(doctor_ed_ex, params, true, nil, self.view, images) { (responce) in
               if number(responce, "status").boolValue {
                 
               } else {
                   Http.alert(appName, string(responce, "result"))
               }
           }
       }
    //MARK: UITABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arr_Exper.count
        }
        return arr_Education.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperinceCell
           
            let dic = arr_Exper[indexPath.row] as? NSDictionary
            
            if indexPath.row != 0 {
                cell.btn_Exper.setTitle("-", for: .normal)
            }
            cell.text_ExStart.text = (dic!["from_date"] as! String)
            cell.text_ExEnd.text = (dic!["to_date"] as! String)
            cell.text_Experience.text = (dic!["hospital_name"] as! String)
            
            cell.text_ExStart.tag = indexPath.row
            cell.text_ExStart.addTarget(self, action: #selector(clcik_OnExpStart), for: .editingDidBegin)

            cell.text_ExEnd.tag = indexPath.row
            cell.text_ExEnd.addTarget(self, action: #selector(clcik_OnExpEnd), for: .editingDidBegin)
            
            cell.text_Experience.tag = indexPath.row
            cell.text_Experience.addTarget(self, action: #selector(clcik_OnExpExperience), for: .editingChanged)

            cell.btn_Exper.tag = indexPath.row
            cell.btn_Exper.addTarget(self, action: #selector(clcik_OnExp), for: .touchUpInside)
            
            return cell
        }
        else  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Edcell", for: indexPath) as! EducationCell
            
            let dic = arr_Education[indexPath.row] as? NSDictionary

            if indexPath.row != 0 {
                cell.btn_Educat.setTitle("-", for: .normal)
            }
            
            cell.text_PassoutDate.tag = indexPath.row
            cell.text_PassoutDate.addTarget(self, action: #selector(clcik_OnEducationDate), for: .editingDidBegin)

            
            cell.text_Education.tag = indexPath.row
            cell.text_Education.addTarget(self, action: #selector(clcik_OnEducationdes), for: .valueChanged)

            
            cell.text_PassoutDate.text = (dic!["passout_date"] as! String)
            cell.text_Education.text = (dic!["education_name"] as! String)

            cell.btn_Educat.tag = indexPath.row
            cell.btn_Educat.addTarget(self, action: #selector(clcik_OnEduca), for: .touchUpInside)
            
            return cell
        }
    }
    @objc func clcik_OnExpStart(butt:UITextField)  {
        self.datePickerTapped(strFormat: "dd/MM/yyyy", mode: .date) { (date) in
            let dic = (self.arr_Exper[butt.tag] as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
            dic["from_date"] = date
            self.arr_Exper.replaceObject(at: butt.tag, with: dic)
            self.table_Expe.reloadData()

        }
    }
    @objc func clcik_OnExpEnd(butt:UITextField)  {
        self.datePickerTapped(strFormat: "dd/MM/yyyy", mode: .date) { (date) in
                  let dic = (self.arr_Exper[butt.tag] as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                  dic["to_date"] = date
                  self.arr_Exper.replaceObject(at: butt.tag, with: dic)
                  self.table_Expe.reloadData()

              }
    }
    @objc func clcik_OnExpExperience(butt:UITextField)  {
        let dic = (self.arr_Exper[butt.tag] as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
        dic["hospital_name"] = butt.text ?? ""
        self.arr_Exper.replaceObject(at: butt.tag, with: dic)
//        self.table_Expe.reloadData()

    }
    
    
    @objc func clcik_OnEducationDate(butt:UITextField)  {
         self.datePickerTapped(strFormat: "dd/MM/yyyy", mode: .date) { (date) in
                   let dic = (self.arr_Education[butt.tag] as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                   dic["passout_date"] = date
                   self.arr_Education.replaceObject(at: butt.tag, with: dic)
                   self.table_Expe.reloadData()
 
               }
     }
     @objc func clcik_OnEducationdes(butt:UITextField)  {
         let dic = (self.arr_Education[butt.tag] as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
         dic["education_name"] = butt.text ?? ""
         self.arr_Education.replaceObject(at: butt.tag, with: dic)
         self.table_Expe.reloadData()
     }
    
    @objc func clcik_OnExp(butt:UIButton)  {
        if butt.tag == 0 {
            let dic:[String:String] = ["from_date":"","to_date":"","hospital_name":""]
            arr_Exper.add(dic)
        } else {
            arr_Exper.removeObject(at: butt.tag)
        }
        let cou = self.arr_Education.count+self.arr_Exper.count
        self.table_Height.constant = CGFloat(166*cou)
        table_Expe.reloadData()

    }
    @objc func clcik_OnEduca(butt:UIButton)  {
        if butt.tag == 0 {
            let dic:[String:String] = ["passout_date":"","education_name":""]
            arr_Education.add(dic)
        } else {
            arr_Education.removeObject(at: butt.tag)
        }
        let cou = self.arr_Education.count+self.arr_Exper.count
        self.table_Height.constant = CGFloat(166*cou)
        table_Expe.reloadData()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 166
    }


}
