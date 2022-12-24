//
//  UIControl.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import UIKit

public extension UIControl {

    private final class Action {
        var action: () -> Void
        var events: UIControl.Event

        init(action: @escaping () -> Void, events: UIControl.Event) {
            self.action = action
            self.events = events
        }
    }

    private struct AssociatedKeys {
        static var ActionName = "action"
    }

    private var actions: [Action] {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? [Action]) ?? [] }
    }

    /**
     Initialize a UIControl, using the given closure as the .TouchUpInside target/action event.

     - parameter action: The closure to execute upon control press.

     - returns: An initialized UIControl.
     */
    convenience init(actionClosure: @escaping () -> Void) {
        self.init()
        addTarget(for: .touchUpInside, actionClosure: actionClosure)
    }

    /**
     Initialize a UIControl with the given frame, using the given closure as the .TouchUpInside target/action event.

     - parameter frame:  The frame of the control.
     - parameter action: the closure to execute upon control press.

     - returns: An initialized UIControl.
     */
    convenience init(frame: CGRect, actionClosure: @escaping () -> Void) {
        self.init(frame: frame)
        addTarget(for: .touchUpInside, actionClosure: actionClosure)
    }

    /**
     Adds the given closure as the control's target action for 'touch up inside' event.
     - parameter action:        The action closure to execute.
     */
    func onTap(actionClosure: @escaping () -> Void) {
        addTarget(for: .touchUpInside, actionClosure: actionClosure)
    }
    
    func onValueChanged(actionClosure: @escaping () -> Void) {
        addTarget(for: .valueChanged, actionClosure: actionClosure)
    }

    /**
     Adds the given closure as the control's target action

     - parameter controlEvents: The UIControlEvents upon which to execute this action.
     - parameter action:        The action closure to execute.
     */
    func addTarget(for controlEvents: UIControl.Event, actionClosure: @escaping () -> Void) {

        actions.append(Action(action: actionClosure, events: controlEvents))

        controlEvents.contains(.touchDown) ? addTarget(self, action: #selector(touchDown), for: .touchDown) : ()
        controlEvents.contains(.touchDownRepeat) ? addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat) : ()
        controlEvents.contains(.touchDragInside) ? addTarget(self, action: #selector(touchDragInside), for: .touchDragInside) : ()
        controlEvents.contains(.touchDragOutside) ? addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside) : ()
        controlEvents.contains(.touchDragEnter) ? addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter) : ()
        controlEvents.contains(.touchDragExit) ? addTarget(self, action: #selector(touchDragExit), for: .touchDragExit) : ()
        controlEvents.contains(.touchUpInside) ? addTarget(self, action: #selector(touchUpInside), for: .touchUpInside) : ()
        controlEvents.contains(.touchUpOutside) ? addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside) : ()
        controlEvents.contains(.touchCancel) ? addTarget(self, action: #selector(touchCancel), for: .touchCancel) : ()
        controlEvents.contains(.valueChanged) ? addTarget(self, action: #selector(valueChanged), for: .valueChanged) : ()
        controlEvents.contains(.editingDidBegin) ? addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin) : ()
        controlEvents.contains(.editingChanged) ? addTarget(self, action: #selector(editingChanged), for: .editingChanged) : ()
        controlEvents.contains(.editingDidEnd) ? addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd) : ()
        controlEvents.contains(.editingDidEndOnExit) ? addTarget(self, action: #selector(editingDidEndOnExit), for: .editingDidEndOnExit) : ()
        controlEvents.contains(.allTouchEvents) ? addTarget(self, action: #selector(allTouchEvents), for: .allTouchEvents) : ()
        controlEvents.contains(.allEditingEvents) ? addTarget(self, action: #selector(allEditingEvents), for: .allEditingEvents) : ()
        controlEvents.contains(.applicationReserved) ? addTarget(self, action: #selector(applicationReserved), for: .applicationReserved) : ()
        controlEvents.contains(.systemReserved) ? addTarget(self, action: #selector(systemReserved), for: .systemReserved) : ()
        controlEvents.contains(.allEvents) ? addTarget(self, action: #selector(allEvents), for: .allEvents) : ()

        if #available(iOS 9.0, *) {
            controlEvents.contains(.primaryActionTriggered) ? addTarget(self, action: #selector(primaryActionTriggered), for: .primaryActionTriggered) : ()
        }
    }
}

extension UIControl {

    private func triggerAction(forEvents events: UIControl.Event) {
        actions.filter { $0.events.contains(events) }.forEach { $0.action() }
    }

    @objc private dynamic func touchDown() {
        triggerAction(forEvents: .touchDown)
    }

    @objc private dynamic func touchDownRepeat() {
        triggerAction(forEvents: .touchDownRepeat)
    }

    @objc private dynamic func touchDragInside() {
        triggerAction(forEvents: .touchDragInside)
    }

    @objc private dynamic func touchDragOutside() {
        triggerAction(forEvents: .touchDragOutside)
    }

    @objc private dynamic func touchDragEnter() {
        triggerAction(forEvents: .touchDragEnter)
    }

    @objc private dynamic func touchDragExit() {
        triggerAction(forEvents: .touchDragExit)
    }

    @objc private dynamic func touchUpInside() {
        triggerAction(forEvents: .touchUpInside)
    }

    @objc private dynamic func touchUpOutside() {
        triggerAction(forEvents: .touchUpOutside)
    }

    @objc private dynamic func touchCancel() {
        triggerAction(forEvents: .touchCancel)
    }

    @objc private dynamic func valueChanged() {
        triggerAction(forEvents: .valueChanged)
    }

    @objc private dynamic func primaryActionTriggered() {
        if #available(iOS 9.0, *) {
            triggerAction(forEvents: .primaryActionTriggered)
        }
    }

    @objc private dynamic func editingDidBegin() {
        triggerAction(forEvents: .editingDidBegin)
    }

    @objc private dynamic func editingChanged() {
        triggerAction(forEvents: .editingChanged)
    }

    @objc private dynamic func editingDidEnd() {
        triggerAction(forEvents: .editingDidEnd)
    }

    @objc private dynamic func editingDidEndOnExit() {
        triggerAction(forEvents: .editingDidEndOnExit)
    }

    @objc private dynamic func allTouchEvents() {
        triggerAction(forEvents: .allTouchEvents)
    }

    @objc private dynamic func allEditingEvents() {
        triggerAction(forEvents: .allEditingEvents)
    }

    @objc private dynamic func applicationReserved() {
        triggerAction(forEvents: .applicationReserved)
    }

    @objc private dynamic func systemReserved() {
        triggerAction(forEvents: .systemReserved)
    }

    @objc private dynamic func allEvents() {
        triggerAction(forEvents: .allEvents)
    }
}


