//
//  ObservableMenu.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import Foundation

class ObservableMenu: ObservableObject {
    @Published var isEnableAll: Bool = false
    @Published var isDisableAll: Bool = false
}
