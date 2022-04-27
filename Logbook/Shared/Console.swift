//
//  Console.swift
//  Logbook
//
//  Created by Thomas on 15.02.22.
//

import Foundation
import LocalConsole


let consoleManager = LCManager.shared

func printError(description: String, errorMessage: String?) {
    consoleManager.print("Error:  \(description)")
    consoleManager.print("=====")
    consoleManager.print(errorMessage ?? "No error description")
    consoleManager.print("=====")
}
