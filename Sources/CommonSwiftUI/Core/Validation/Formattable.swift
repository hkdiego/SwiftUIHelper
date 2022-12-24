//
//  Formattable.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation

public protocol Formattable {
    var pattern: String { get }
    var replacementCharacter: Character { get }
    var regEx: String { get }
    func format(string: String) -> String
    func unFormat(string: String) -> String
}

public extension Formattable  {
    
    var replacementCharacter: Character { return "#"}
    
    func format(string: String) -> String {
        
        var formattedString = string.replacingOccurrences(of: regEx, with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < formattedString.count else { return formattedString }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            formattedString.insert(patternCharacter, at: stringIndex)
        }
        
        if formattedString.count > pattern.count {
            while formattedString.count > pattern.count {
                formattedString.removeLast()
            }
        }
        return formattedString
    }
    
    func unFormat(string: String) -> String {
        let formattedString = string.replacingOccurrences(of: regEx, with: "", options: .regularExpression)
        return formattedString
    }
}

public struct Formatter: Formattable {
    public var pattern: String
    public var regEx: String
    
    public init(type: FormatType) {
        pattern = type.format.pattern
        regEx = type.format.regEx
    }
    
    public enum FormatType {
        case phone
        case activationCode
        case verificationPin
        case userName
        case numbers(count: Int)
        case text(limit: Int)
        
        public var format: (pattern: String, regEx: String) {
            switch self {
                /// "+# (###)-###-####"
                case .phone:            return (
                    pattern: "+# (###)-###-####",
                    regEx: "[^0-9]")
                
                /// "####-####-####-####"
                case .activationCode:   return (
                    pattern: "####-####-####-####",
                    regEx: "[^a-zA-Z0-9]")
                
                /// "####"
                case .verificationPin:  return (
                    pattern: "######",
                    regEx: "[^0-9.,-]")
                
                /// 46 symbols "[^a-zA-Z0-9!\"#$%&'()_.@]"
                case .userName:         return (
                    pattern: Array.init(repeating: "#", count: 46).joined(separator: ""),
                    regEx: "[^a-zA-Z0-9!\"#$%&'()_.@]")
                
                /// digits "[^0-9.,-]"
                case .numbers(let count):          return (
                    pattern: Array.init(repeating: "#", count: count).joined(separator: ""),
                    regEx: "[^0-9.,-]")
                
                /// text "[a-zA-Z0-9!\"#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]+"
                case .text(let charCount):  return (
                    pattern: Array.init(repeating: "#", count: charCount).joined(separator: ""),
                    regEx: "[a-zA-Z0-9!\"#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]+")
            }
        }
    }
    
    /// "+# (###)-###-####"
    public static let phone = Formatter(type: .phone)
    /// "####-####-####-####"
    public static let activationCode = Formatter(type: .activationCode)
    /// "######"
    public static let verificationPin = Formatter(type: .verificationPin)
    /// 46 symbols "[^a-zA-Z0-9!\"#$%&'()_.@]"
    public static let userName = Formatter(type: .userName)
    /// "3 digits "[^0-9.,-]""
    public static let weight = Formatter(type: .numbers(count: 5))
}

