//
//  LoadingState.swift
//  Voice Translator
//
//  Created by Aleksandr Nesterov on 14.10.2020.
//

import Foundation

public enum LoadingState<Model> {
    case idle
    case loading
    case success(Model)
    case error(Error)
}
