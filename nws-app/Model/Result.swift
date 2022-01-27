//
//  Result.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 24.01.22.
//

import Foundation

enum Result<Value> {
    case success(value: Value)
    case failure(error: Error)
}
