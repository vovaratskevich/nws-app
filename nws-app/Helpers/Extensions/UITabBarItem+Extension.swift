//
//  UITabBarItem.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import UIKit

extension UITabBarItem {
    
    convenience init(image: UIImage) {
        self.init(title: nil, image: image, selectedImage: nil)
        imageInsets =  UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }
    
}
