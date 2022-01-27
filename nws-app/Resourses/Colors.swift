//
//  Colors.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import Foundation

import UIKit

struct Color {
    static let blue = UIColor(named: "app-blue") ?? .systemBlue
    static let brightBlue = UIColor(named: "app-brightBlue") ?? .systemBlue
    static let coral = UIColor(named: "app-coral") ?? .systemRed
    static let brightCoral = UIColor(named: "app-brightCoral") ?? .systemRed
    static let yellow = UIColor(named: "app-yellow") ?? .systemYellow
    static let brightYellow = UIColor(named: "app-brightYellow") ?? .systemYellow
    static let red = UIColor(named: "app-red") ?? .systemRed
    static let darkRed = UIColor(named: "app-dark-red") ?? .systemRed
    static let green = UIColor(named: "app-button-done-hover") ?? .systemBlue
    static let brightGreen = UIColor(named: "app-button-done-normal") ?? .systemBlue
    static let gray = UIColor(named: "app-gray") ?? .systemGray
    
    static let shadow = UIColor.black.withAlphaComponent(0.15)
    
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
