//
//  DI.swift
//  
//
//  Created by Aleksandr Nesterov on 18.11.2020.
//

import Foundation

public struct Name: Equatable {
    let rawValue: String
    public static let `default` = Name(rawValue: "__default__")
    public static func == (lhs: Name, rhs: Name) -> Bool { lhs.rawValue == rhs.rawValue }
}

public final class Container {
    private var dependencies: [(key: Name, value: Any)] = []
    
    public static let `default` = Container()
    
    public func register(_ dependency: Any, for key: Name = .default) {
        dependencies.append((key: key, value: dependency))
    }
    
    public func clear() {
        dependencies = []
    }
    
    func resolve<T>(_ key: Name = .default) -> T {
        return (dependencies.first(where: { $0.key == key && $0.value is T }))?.value as! T
    }
}

@propertyWrapper
public struct Inject<T> {
    private let dependencyName: Name
    private let container: Container
    
    public var wrappedValue: T {
        return container.resolve(dependencyName)
    }
    
    public init(_ dependencyName: Name = .default, on container: Container = .default) {
        self.dependencyName = dependencyName
        self.container = container
    }
}
