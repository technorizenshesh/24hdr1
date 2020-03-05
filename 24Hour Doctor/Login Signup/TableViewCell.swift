//
//  TableViewCell.swift
//  VCARDY
//
//  Created by Technorizen on 8/10/17.
//  Copyright © 2017 Technorizen. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var btn_24: UIButton!
    
    //Review
    @IBOutlet weak var img_Review: UIImageView!
    @IBOutlet weak var btn_RevewiReport: UIButton!
    @IBOutlet weak var lbl_ReviewMessage: UILabel!
    @IBOutlet weak var lbl_ReviewDate: UILabel!
//    @IBOutlet weak var rating_Review: CosmosView!
    @IBOutlet weak var lbl_ReviewName: UILabel!
    @IBOutlet weak var btn_ReviewComment: UIButton!
    //Commisson
    @IBOutlet weak var lbl_MerchantName: UILabel!
    @IBOutlet weak var lbl_Affilatenumber: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_PhoneNumber: UILabel!
    @IBOutlet weak var img_merc: UIImageView!
    
    //Commision
    @IBOutlet weak var lbl_Commison: UILabel!
    @IBOutlet weak var btn_Withdr: UIButton!
    @IBOutlet weak var lbl_DateCom: UILabel!
    @IBOutlet weak var lbl_WeeklyCommsion: UILabel!
    
    //MARK:Activity
   
    @IBOutlet weak var lbl_MemName: UILabel!
    @IBOutlet weak var btn_Chat: UIButton!
    @IBOutlet weak var btn_three: UIButton!
    @IBOutlet weak var lbl_totalPayment: UILabel!
    @IBOutlet weak var lbl_paymencategory: UILabel!
    @IBOutlet weak var lbl_NgCash: UILabel!
    @IBOutlet weak var lbl_PaymentCard: UILabel!
    @IBOutlet weak var lbl_cardType: UILabel!
    @IBOutlet weak var lbl_orderdate: UILabel!
    @IBOutlet weak var lbl_OrderId: UILabel!
    
    //MARK:Address
    @IBOutlet weak var img_checkAdress: UIImageView!
    @IBOutlet weak var lbl_PhoneAddess: UILabel!
    
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var lbl_FullName: UILabel!
    
    @IBOutlet weak var lbl_street: UILabel!
    @IBOutlet weak var lbl_Aprtment: UILabel!
    @IBOutlet weak var img_CheckSizeorColor: UIImageView!
    @IBOutlet weak var lbl_EstimateDeliver: UILabel!
    @IBOutlet weak var lbl_SizeOrColor: UILabel!
    //MARK:Message
    
    @IBOutlet var btn_Delete: UIButton!
    @IBOutlet var lbl_lastConversionChat: UILabel!
    @IBOutlet var lbl_UsrnameChat: UILabel!
    @IBOutlet var lbl_TimeChat: UILabel!
    @IBOutlet var img_MemberChat: UIImageView!
    
    //MARK:CustomerReview

    @IBOutlet weak var lbl_LikeCount: UILabel!
    @IBOutlet weak var like_Review: UIButton!
    @IBOutlet var lbl_Comment_By_Member: UILabel!
    @IBOutlet var lbl_Date: UILabel!
    @IBOutlet var img_MeberForReview: UIImageView!

    @IBOutlet var lbl_Member_Name: UILabel!
    //MARK:CardDetail

    @IBOutlet var btn_EditCard: UIButton!
    @IBOutlet var lbl_card_Name: UILabel!
    
    //MARK:MerchantOffer

    @IBOutlet var btn_threeActiveOffer: UIButton!
    @IBOutlet var img_Offer: UIImageView!
    @IBOutlet var lbl_PriceWithPercent: UILabel!
    @IBOutlet var lbl_Offer_title: UILabel!
    @IBOutlet var lbl_offerDay: UILabel!
    @IBOutlet var lbl_offer_Description: UILabel!
 
    //MARK:MerchantProfile
    
    @IBOutlet var btn_OpenClose: UIButton!
    @IBOutlet var btn_On_StartAndEnd: UIButton!
    @IBOutlet var lbl_Day: UILabel!
    @IBOutlet var text_Start_Time: UITextField!
    @IBOutlet var text_Ent_Time: UITextField!
    
    //
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var btn_Add: UIButton!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblVehicleReg: UILabel!
    @IBOutlet var lblContactNum: UILabel!
    
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var imgBG: UIImageView!
    @IBOutlet var switchCell: UISwitch!
    
    @IBOutlet var btnContact: UIButton!

    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPriceFor: UILabel!
    @IBOutlet var lblAdd: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    // MARK:- ProductList
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDealPrice: UILabel!
    @IBOutlet var lblSave: UILabel!
    @IBOutlet var customerReview: UILabel!
    @IBOutlet var lblClaimedDeal: UILabel!
    @IBOutlet var btnAddTocart: UIButton!
    
    
    // Cart List
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnSub: UIButton!
    @IBOutlet var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    //MARK:- Set Product Item
//    func setItem(dictItem : NSDictionary,forItem : String)  {
//        print(dictItem)
//        let dic = dictItem["product_detail"] as! NSDictionary
//
//        let strImage = dic["thumbnail_image"] as! String
//        let downloadURL = NSURL(string: strImage.replace(target: " ", withString: "%20"))
//        print(downloadURL)
//        imgProduct.sd_setImage(with: downloadURL as URL?, placeholderImage: UIImage.init(named:""), options: SDWebImageOptions(rawValue: 1), completed: nil)
//        lblProductName.text = dic["product_name"] as? String
//        lblDescription.text = dic["product_description"] as? String
//        lblPrice.text = "$\(dic["price"] as! String)"
//        if forItem == "Cart" {
//           lblAdd.text = dictItem["quantity"] as? String
//
//
//        }
//    }
//    //MARK:- Set Category
//    func setCategory(dictItem : NSDictionary)  {
//        print(dictItem)
//        let strImage = dictItem["category_image"] as! String
//        let downloadURL = NSURL(string: strImage)
//        imgProduct.af_setImage(withURL: downloadURL! as URL, placeholderImage: #imageLiteral(resourceName: "noImagePlaceHolder.jpg"))
//        lblProductName.text = "\t\(dictItem["category_name"] as! String)\t"
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//}
//
//class SenderCell: UITableViewCell {
//
//    @IBOutlet weak var profilePic: RoundedImageView!
//
//    @IBOutlet weak var message: UITextView!
//    @IBOutlet weak var messageBackground: UIImageView!
//
//    func clearCellData()  {
//        self.message.text = nil
//        self.message.isHidden = false
//        self.messageBackground.image = nil
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.selectionStyle = .none
//        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
//        self.messageBackground.layer.cornerRadius = 15
//        self.messageBackground.clipsToBounds = true
//    }
//}
//class RoundedImageView: UIImageView {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let radius: CGFloat = self.bounds.size.width / 2.0
//        self.layer.cornerRadius = radius
//        self.clipsToBounds = true
//    }
//}
//class ReceiverCell: UITableViewCell {
//
//    @IBOutlet weak var message: UITextView!
//    @IBOutlet weak var messageBackground: UIImageView!
//
//    func clearCellData()  {
//        self.message.text = nil
//        self.message.isHidden = false
//        self.messageBackground.image = nil
//    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.selectionStyle = .none
////        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
////        self.messageBackground.layer.cornerRadius = 15
////        self.messageBackground.clipsToBounds = true
//    }
}

