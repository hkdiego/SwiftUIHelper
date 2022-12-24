//
//  Binding.swift
//  
//
//  Created by Aleksandr Nesterov on 02.12.2020.
//

import Foundation
import SwiftUI


public prefix func !(value: Binding<Bool>) -> Binding<Bool> {
    return Binding<Bool>(get: { return !value.wrappedValue },
                         set: { b in value.wrappedValue = b })
}

public extension Binding where Value == Bool {
    var not: Binding<Value>  {
        return Binding<Value>(get: { return !self.wrappedValue },
                              set: { b in self.wrappedValue = b })
    }
}

public extension Binding where Value == Bool {
    var anti: Binding<Value>  {
        return Binding<Value>(get: { return !self.wrappedValue },
                              set: { b in self.wrappedValue = !b })
    }
}

public extension Binding {
    func map<V>(_ f: @escaping (Value) -> V, r: @escaping (V) -> Value) -> Binding<V> {
        return Binding<V>(get: { return f(self.wrappedValue) },
                          set: { b in self.wrappedValue = r(b) })
    }
}
