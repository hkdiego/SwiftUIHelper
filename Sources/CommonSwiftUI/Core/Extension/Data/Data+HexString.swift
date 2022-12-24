//
//  Data.swift
//  
//
//  Created by Aleksandr Nesterov on 01.12.2020.
//

import Foundation

public extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
