//
//  UserDefault.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 18.10.2020.
//

import Foundation

@propertyWrapper
public struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data,
               let value = try? JSONDecoder().decode(T.self, from: data) {
                return value
            }
            return  defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
