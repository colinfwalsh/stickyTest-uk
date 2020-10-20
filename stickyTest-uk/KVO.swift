//
//  KVO.swift
//  Hollywood Sportsbook
//
//  Created by Varun Goyal on 11/19/19.
//  Copyright © 2019 Penn National Gaming, Inc. All rights reserved.
//

import UIKit
import Foundation

extension Array where Element == NSKeyValueObservation {
    /// Convenience method to invalidate all observations in an array
    func invalidate() {
        forEach { $0.invalidate() }
    }
}

extension NSObjectProtocol where Self: NSObject {
    func observe<Value>(_ keyPath: KeyPath<Self, Value>, options: NSKeyValueObservingOptions = [.initial, .new], onChange: @escaping (Value) -> Void) -> NSKeyValueObservation {
        return observe(keyPath, options: options) { [weak self] _, _ in
            guard let self = self else { return }
            onChange(self[keyPath: keyPath])
        }
    }
    
    /**
     * Observe a key path for a change in value.  Verifies that the value has actually changed and provides both the old
     * and new values to the callback.
     */
    func observeEnsureChanged<Value: Equatable>(
        _ keyPath: KeyPath<Self, Value>,
        options: NSKeyValueObservingOptions = [.initial, .new, .old],
        onChange: @escaping (_ newValue: Value, _ oldValue: Value) -> Void) -> NSKeyValueObservation {
        let fullOptions = options.union([.new, .old])
        var first = true
        var lastValue: Value = self[keyPath: keyPath]
        func compareAndNotify(newValue: Value) {
            if first || newValue != lastValue {
                let oldValue = lastValue
                first = false
                lastValue = newValue
                onChange(newValue, oldValue)
            }
        }
        
        return observe(keyPath, options: fullOptions) { [weak self] _, _ in
            guard let self = self else { return }
            let value: Value = self[keyPath: keyPath]
            compareAndNotify(newValue: value)
        }
    }
    
    func bind<Value, Target>(_ sourceKeyPath: KeyPath<Self, Value>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { target[keyPath: targetKeyPath] = $0 }
    }
    
    /**
     Binds the String from the sourceKeyPath to the target's title label
     */
    func bind(_ sourceKeyPath: KeyPath<Self, String?>, to target: UIButton) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { (value) in
            target.setTitle(value, for: .normal)
        }
    }
    
    /**
     Binds the Int from the sourceKeyPath to the targetKeyPath as a Float value
     */
    func bind<Target>(asFloat sourceKeyPath: KeyPath<Self, Int>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Float>) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { target[keyPath: targetKeyPath] = Float($0) }
    }
    
    /**
     Negates the value from the provided sourceKeyPath before applying it on the targetKeyPath
     */
    func bind<Target: UIView>(negating sourceKeyPath: KeyPath<Self, Bool>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Bool>) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { target[keyPath: targetKeyPath] = !$0 }
    }
    
    func bind<Value, Target: UIView>(_ sourceKeyPath: KeyPath<Self, Value>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { target[keyPath: targetKeyPath] = $0 }
    }
}
