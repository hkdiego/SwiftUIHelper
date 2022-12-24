//
//  LoadableObject.swift
//  Voice Translator
//
//  Created by Aleksandr Nesterov on 14.10.2020.
//

import Foundation

public protocol LoadableObject: ObservableObject {
    associatedtype Output
    
    var state: LoadingState<Output> { get }
    func load()
}
