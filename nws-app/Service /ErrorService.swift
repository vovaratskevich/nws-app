//
//  ErrorService.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 24.01.22.
//

import Foundation

enum ErroService: Error {
    case failedURL
    case failedParse
    case failedLoadData
}
