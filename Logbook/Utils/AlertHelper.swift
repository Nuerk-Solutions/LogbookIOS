//
//  AlertHelper.swift
//  Logbook
//
//  Created by Thomas Nürk on 18.02.24.
//

import Foundation
import AlertKit

func showSpinningAlert(title: String = "Senden...", icon: AlertIcon = .spinnerSmall, haptic: AlertHaptic = .none) {
    AlertKitAPI.present(
              title: title,
              icon: icon,
              style: .iOS17AppleMusic,
              haptic: haptic
          )
}

func showSuccessfulAlert(title: String = "Eintrag hinzugefügt", icon: AlertIcon = .done, haptic: AlertHaptic = .success) {
    AlertKitAPI.present(
              title: title,
              icon: icon,
              style: .iOS17AppleMusic,
              haptic: haptic
          )
}

func showFailureAlert(title: String = "Fehler beim speichern", icon: AlertIcon = .error, haptic: AlertHaptic = .error) {
        AlertKitAPI.present(
            title: title,
            icon: icon,
            style: .iOS16AppleMusic,
            haptic: haptic
        )
}

func dismissAllAlerts() {
        AlertKitAPI.dismissAllAlerts()
}
