//
//  AlertModel.swift
//  Logbook
//
//  Created by Thomas on 19.12.21.
//

import Foundation

class AlertViewModel: ObservableObject {
    
    @Published var show = false
    @Published var duration: Double = 2
    @Published var tapToDismiss = false
//    @Published var alertToast = AlertToast(displayMode: .alert, type: .regular, title: "Hello World") {
//        didSet {
//            print(duration)
//            self.show.toggle()
//            if(!tapToDismiss){
//                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
//                    self.show.toggle()
//                }
//            }
//        }
//    }
}
