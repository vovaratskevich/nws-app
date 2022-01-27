//
//  Extensions.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 19.01.22.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func setupView() {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.15)
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.6
    }
    
}
