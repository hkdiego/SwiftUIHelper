//
//  TextInput.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import SwiftUI

public struct TextInput: UIViewRepresentable {
    
    private let onBegin: () -> Void
    private let onChange: (String) -> Void
    private let onEnd: () -> Void
    private let onReturn: (String) -> Void
    
    private let placeholder : String
    private let keyboardType: UIKeyboardType
    private let returnKeyType: UIReturnKeyType
    private let isSecureTextEntry: Bool
    private let autocorrectionType: UITextAutocorrectionType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let font: UIFont
    private let placeholderFont: UIFont
    private let clearButtonMode: UITextField.ViewMode
    private let textAlignment: NSTextAlignment
    
    private let text: Binding<String>
    private let isResponder: Binding<Bool>?
    private let nextResponder: Binding<Bool>?
    private let showAccessoryView: Bool
    private let tintColor: UIColor
    private let textColor: UIColor
    private let placeholderColor: UIColor
    
    public init(text: Binding<String>,
         placeholder: String = "",
         font: UIFont,
         placeholderFont: UIFont,
         clearButtonMode: UITextField.ViewMode = .never,
         alignment: NSTextAlignment = .center,
         isResponder: Binding<Bool>? = nil,
         nextResponder: Binding<Bool>? = nil,
         keyboardType: UIKeyboardType = .default,
         returnKeyType: UIReturnKeyType = .default,
         isSecureTextEntry: Bool = false,
         autocorrectionType: UITextAutocorrectionType = .default,
         autocapitalizationType: UITextAutocapitalizationType = .none,
         showAccessoryView: Bool = false,
         tintColor: UIColor,
         textColor: UIColor,
         placeholderColor: UIColor,
         responderParameters: ResponderParameters? = nil,
         onBegin: @escaping () -> Void = {},
         onChange: @escaping (String) -> Void = { _ in },
         onEnd: @escaping () -> Void = {},
         onReturn: @escaping (String) -> Void = { _ in }) {
        
        self.text = text
        self.isResponder = isResponder
        self.nextResponder = nextResponder
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isSecureTextEntry
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.font = font
        self.placeholderFont = placeholderFont
        self.clearButtonMode = clearButtonMode
        self.textAlignment = alignment
        self.showAccessoryView = showAccessoryView
        self.tintColor = tintColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.onBegin = onBegin
        self.onChange = onChange
        self.onEnd = onEnd
        self.onReturn = onReturn
    }
    
    public func makeCoordinator() -> Self.Coordinator {
        Coordinator(self, isResponder: isResponder, nextResponder: nextResponder)
    }

    public func makeUIView(context: UIViewRepresentableContext<TextInput>) -> CustomUITextField {
        
        let textField = CustomUITextField().then {
            $0.text = text.wrappedValue
            $0.tintColor = tintColor
            $0.font = font
            $0.keyboardType = keyboardType
            $0.returnKeyType = returnKeyType
            $0.textColor = textColor
            $0.textAlignment = textAlignment
            $0.isSecureTextEntry = isSecureTextEntry
            $0.autocorrectionType = autocorrectionType
            $0.autocapitalizationType = autocapitalizationType
            $0.clearButtonMode = clearButtonMode
            $0.delegate = context.coordinator
            $0.attributedPlaceholder = placeholder.attributed
                                                  .font(placeholderFont)
                                                  .paint(with: placeholderColor)
        }
        
//        if showAccessoryView {
//            textField.inputAccessoryView = KeyboardAccessoryView.returnButton(text: text, type: returnKeyType) { [weak textField] in
//                guard let field = textField else { return }
//                _ = field.delegate?.textFieldShouldReturn?(field)
//            }
//        }
        
        updateResponder(field: textField)
        context.coordinator.setup(textField)
        return textField
    }

    public func updateUIView(_ uiView: CustomUITextField, context: UIViewRepresentableContext<TextInput>) {
        uiView.text = self.text.wrappedValue
        uiView.isSecureTextEntry = self.isSecureTextEntry
        DispatchQueue.main.async { updateResponder(field: uiView) }
    }
    
    ///ATTENTION: DispatchQueue.main.async should be in updateUIView and before field.responderAction.
    ///otherwise, during switching fields some visual bugs may appear
    private func updateResponder(field: UITextField) {
        guard let isResponder = self.isResponder else { return }
        if isResponder.wrappedValue {
            DispatchQueue.main.async { field.becomeFirstResponder() }
        } else if nextResponder?.wrappedValue == false {
            DispatchQueue.main.async { field.resignFirstResponder() }
        }
    }
    
    //MARK: - Coordinator
    public final class Coordinator: NSObject, UITextFieldDelegate {
        private var container: TextInput
        private let isResponder: Binding<Bool>?
        private let nextResponder: Binding<Bool>?
        
        public init(_ textFieldContainer: TextInput,
             isResponder: Binding<Bool>? = nil,
             nextResponder: Binding<Bool>? = nil) {
            
            self.container = textFieldContainer
            self.isResponder = isResponder
            self.nextResponder = nextResponder
        }

        public func setup(_ textField: UITextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder?.wrappedValue = true
            }
            container.onBegin()
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            let value = textField.text ?? ""
            container.text.wrappedValue = value
            container.onChange(value)
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async {
                self.isResponder?.wrappedValue = false
                if let next = self.nextResponder {
                    next.wrappedValue = true
                } else {
                    textField.resignFirstResponder()
                }
            }
            container.onReturn(textField.text ?? "")
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder?.wrappedValue = false
            }
            container.onEnd()
        }
    }
}


public final class CustomUITextField: UITextField, ParameterizedResponder {
    
    public var responderParameters: ResponderParameters? = nil
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
    }
}
