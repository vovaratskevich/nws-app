//
//  String+Extension.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import UIKit

extension String {
    
    var withoutHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    var replaceOrgToBy: String {
        return self.replacingOccurrences(of: "org", with: "by", options: .literal, range: nil)
    }
    
}
