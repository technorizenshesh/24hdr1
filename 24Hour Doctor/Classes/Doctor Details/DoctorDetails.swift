//
//  DoctorDetails.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DoctorDetails: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!

    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionRating(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: FUNCTIONS
    
}//Class End


