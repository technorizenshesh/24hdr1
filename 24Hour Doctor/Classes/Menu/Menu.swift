//
//  Menu.swift
//  BigPaya
//
//  Created by mac on 02/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SDWebImage

class Menu: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet var tblView: UITableView!
    
    //MARK: VARIABLES
    let arrMenu = NSMutableArray()
    var walletAmount = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        tblView.tableFooterView = UIView()
        createMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblUserName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
        imgProfile.sd_setImage(with: URL.init(string: string(kAppDelegate.userInfo, "image")), placeholderImage: UIImage.init(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: FUNCTIONS
    func createMenu() {
        arrMenu.add(getMutable(["title": "Home", "image": "menu_home", "status": "0"]))

        arrMenu.add(getMutable(["title": "Appointment", "image": "menu_appointment", "status": "0"]))
        arrMenu.add(getMutable(["title": "Chat", "image": "menu_chat", "status": "0"]))
        arrMenu.add(getMutable(["title": "Profile", "image": "menu_profile", "status": "0"]))
        arrMenu.add(getMutable(["title": "Settings", "image": "menu_setting", "status": "0"]))
        arrMenu.add(getMutable(["title": "Logout", "image": "menu_logout", "status": "0"]))
        tblView.reloadData()
    }
    
    func getMutable(_ dt:Dictionary<String, Any>) -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: dt)
    }
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let dict = arrMenu.object(at: indexPath.row) as! NSMutableDictionary
        cell.lblTitle.text = string(dict, "title")
        cell.imgTitle.image = UIImage(named: string(dict, "image"))
        
        if string(dict, "status") == "1" {
            cell.backgroundColor = PredefinedConstants.appColor().withAlphaComponent(0.8)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<arrMenu.count {
            let dictMenu =  arrMenu.object(at: i) as! NSMutableDictionary
            dictMenu.setValue("0", forKey: "status")
            arrMenu.replaceObject(at: i, with: dictMenu)
        }
        
        let dict = arrMenu.object(at: indexPath.row) as! NSMutableDictionary
        dict.setValue("1", forKey: "status")
        arrMenu.replaceObject(at: indexPath.row, with: dict)
        tblView.reloadData()
        
        //Push View Controller
        
        let strTitle = dict.object(forKey: "title") as! String
        //AvailabilityNav
        if strTitle == "Home" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "RootView"), animated: true)
                self.sideMenuViewController.hideViewController()
            
        } else if strTitle == "Appointment" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "Apoointment"), animated: true)
                self.sideMenuViewController.hideViewController()
            
        }  else if strTitle == "Chat" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "ChatNav"), animated: true)
                self.sideMenuViewController.hideViewController()
            
        } else if strTitle == "Profile" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "ProfileNav"), animated: true)
                self.sideMenuViewController.hideViewController()
        } else if strTitle == "Settings" {
           self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "SettingVC"), animated: true)
                self.sideMenuViewController.hideViewController()
        } else if strTitle == "Logout" {
                self.sideMenuViewController.hideViewController()
                Http.alert(AlertMsg.strAlert, AlertMsg.logoutMsg, [self, "Yes", "No"])
        }
    }
    
    override func alertZero() {
        kAppDelegate.logOut()
    }
    
    

}//Class End.

