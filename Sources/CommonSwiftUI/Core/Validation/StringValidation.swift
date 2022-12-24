//
//  StringValidation.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation

public extension Validator where Value == String {
    static func pattern(_ pattern: String, errorMessage: String) -> Validator<String> {
        return .block(message: errorMessage) {
            return $0.trimmed.matches(regex: pattern)
        }
    }
    
    static var any: Validator<String> {
        return .block() { _ in return true }
    }
    
    static var none: Validator<String> {
        return .block() { _ in return false }
    }
    
    static var empty: Validator<String> {
        return .block() { $0.isEmpty }
    }
    
    static var notEmpty: Validator<String> {
        return .block() { !$0.isEmpty }
    }
}

public extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func matches(regex pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) == startIndex..<endIndex
    }
}

public extension Validator where Value == String {
    
    static func email(errorMessage: String) -> Validator<String> {
        return pattern(
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
            errorMessage: errorMessage
        )
    }
    
    static func phone(errorMessage: String) -> Validator<String> {
        return pattern(
            "\\+[0-9]{1,2} \\([0-9]{3}\\)-[0-9]{3}-[0-9]{4}$",
            errorMessage: errorMessage
        )
    }
    
    static func empty(errorMessage: String) -> Validator<String> {
        let message = errorMessage
        return .block(message: message) { !$0.isEmpty }
    }
    
    static func notEmpty(errorMessage: String) -> Validator<String> {
        return .block(message: errorMessage) { $0.isEmpty }
    }
    
    static func zip(errorMessage: String) -> Validator<String> {
        return pattern(
            "^\\d{5}(?:[-\\s]\\d{4})?$",
            errorMessage: errorMessage
        )
    }
    
    static func number(errorMessage: String) -> Validator<String> {
        return pattern(
            "^(?=.+)(?:[1-9]\\d*|0)?(?:\\.\\d+)?$",
            errorMessage: errorMessage
        )
    }
    
    static func digits(count: Int, errorMessage: String) -> Validator<String> {
        return pattern(
            "[0-9]{\(count)}",
            errorMessage: errorMessage
        )
    }
    
    static func min(_ min: Int, _ errorMessage: String) -> Validator<String> {
        let message = errorMessage
        return .block(message: message) {
            $0.trimmed.count >= min
        }
    }
    
    static func max(_ max: Int, _ errorMessage: String) -> Validator<String> {
        let message = errorMessage
        return .block(message: message) {
            $0.trimmed.count <= max
        }
    }
    
    static func name(errorMessage: String) -> Validator<String> {
        return pattern(
            "^[a-zA-Z ,\\.'-]+$",
            errorMessage: errorMessage
        )
    }
}
