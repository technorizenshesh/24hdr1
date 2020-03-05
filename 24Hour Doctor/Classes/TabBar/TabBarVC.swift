//
//  TabBarVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let numberOfItems = CGFloat(tabBar.items!.count)
//        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height + 20)
//        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: PredefinedConstants.appColor(), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0))
//        let img = UIImage()
//        img.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 20))
//        // remove default border
//        tabBar.frame.size.width = self.view.frame.width + 4
//        tabBar.frame.origin.x = -2
//        UITabBar.appearance().tintColor = UIColor.white
    }
    

}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
