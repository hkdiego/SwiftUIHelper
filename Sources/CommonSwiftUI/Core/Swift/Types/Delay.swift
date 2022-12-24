//
//  Delay.swift
//  
//
//  Created by Aleksandr Nesterov on 16.11.2020.
//

import Foundation

public extension TimeInterval {
    static var oneFrame: TimeInterval {
        return 1 / 60.0
    }

    static var halfSecond: TimeInterval {
        return 1 / 2.0
    }

    static var oneSecond: TimeInterval {
        return 1
    }

    static var oneDay: TimeInterval {
        return 60 * 60 * 24
    }

    static var twoDays: TimeInterval {
        return 60 * 60 * 24 * 2
    }

    static var treeDays: TimeInterval {
        return 60 * 60 * 24 * 3
    }

    static var oneWeek: TimeInterval {
        return 60 * 60 * 24 * 7
    }

    static var oneMonth: TimeInterval {
        return 60 * 60 * 24 * 30
    }

    static var oneYear: TimeInterval {
        return 60 * 60 * 24 * 366
    }
}

public func delay(_ delay: Double, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
