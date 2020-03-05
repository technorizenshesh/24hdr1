//
//  AppointmentCell.swift
//  24Hour Doctor
//
//  Created by mac on 23/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var imgBg: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
