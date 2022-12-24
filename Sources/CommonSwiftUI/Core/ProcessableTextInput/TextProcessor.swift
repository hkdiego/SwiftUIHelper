//
//  TextProcessor.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import SwiftUI

public final class TextProcessor: ObservableObject, Validatable, Formattable {
    
    //Formattable
    public var pattern: String = ""
    public var regEx: String = ""
    private var format: Formattable?
    
    //ValidatableView
    public var valueChanged: (String) -> Void = { _ in }
    public var validator: Validator<String>?
    public var viewValidationState: ViewValidationState = .empty {
        didSet {
            guard viewValidationState != oldValue else { return }
            errorMessage = viewValidationState.errorMessage ?? ""
        }
    }
    
    public var value: String  {
        get { formattedValue }
        set {
            operatedValue = newValue
            valueChanged(formattedValue)
        }
    }
    
    private var formattedValue: String = ""
    private var operatedValue: String {
        get {
            return value
        }
        set {
            let formatted = format(string: newValue)
            if format != nil, formatted != newValue {
                formattedValue = formatted
            } else {
                formattedValue = newValue
            }
            showValidationResult()
            isValid = viewValidationState.isValid
            isEmpty = value.isEmpty
        }
    }
    
    public var unformattedValue: String {
        return unFormat(string: value)
    }
    
    @Published public var isValid: Bool = false
    
    @Published public var errorMessage: String = ""
    
    @Published public var isEmpty: Bool = true
    
    
    public init(initialVal: String = "", validator: Validator<String>, format: Formattable? = nil) {
        self.validator = validator
        self.format = format
        if let f = format {
            pattern = f.pattern
            regEx = f.regEx
        }
        if initialVal.isNotEmpty {
            value = initialVal
        }
    }
}
