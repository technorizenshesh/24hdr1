//
//  MyTableViewCell.swift
//  24Hour Doctor
//
//  Created by mac on 22/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Reason: UILabel!
    @IBOutlet weak var img_Check: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
