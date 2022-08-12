//
//  Preferences.swift
//  Logbook
//
//  Created by Thomas on 12.06.22.
//

import Foundation
import Combine

final class PreferenceManager {
    
    static let standard = PreferenceManager(userDefaults: .standard)
    private(set) var userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    @UserDefault("currentDriver")
    var currentDriver: DriverEnum = .Andrea
    
    @UserDefault("isAllowLocationTracking")
    var isAllowLocationTracking: Bool = true
    
    @UserDefault("isShowNotifications")
    var isShowNotifications: Bool = false
    
    @UserDefault("isShowNotificationsIconBadge")
    var isShowNotificationsIconBadge: Bool = false
    
    @UserDefault("isOpenAddViewOnStart")
    var isOpenAddViewOnStart: Bool = false
    
    @UserDefault("isRememberLastDriver")
    var isRememberLastDriver: Bool = false
    
    @UserDefault("isLiteMode")
    var isLiteMode: Bool = true
    
    @UserDefault("isIntelligentGasStationRadius")
    var isIntelligentGasStationRadius: Bool = true
    
    @UserDefault("isIntelligentGasStationSelection")
    var isIntelligentGasStationSelection: Bool = false
    
    @UserDefault("isUseNotSuperScript")
    var isUseNotSuperScript: Bool = true
}

