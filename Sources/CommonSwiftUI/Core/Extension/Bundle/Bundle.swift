//
//  Bundle.swift
//  
//
//  Created by Aleksandr Nesterov on 16.11.2020.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
