//
//  Preference.swift
//  Logbook
//
//  Created by Thomas on 12.06.22.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<PreferenceManager, Value>
    private let preferences: PreferenceManager
    
    init(_ keyPath: ReferenceWritableKeyPath<PreferenceManager, Value>, preferences: PreferenceManager = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }
    
    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set {
            withAnimation {
                preferences[keyPath: keyPath] = newValue
            }
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

private final class PublisherObservableObject: ObservableObject {
    
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
