//
//  ObservableMenu.swift
//  Reminder
//
//  Created by Rujax on 2023/9/6.
//

import Foundation

class ObservableMenu: ObservableObject {
    @Published var isEnableAll: Bool = false
    @Published var isDisableAll: Bool = false
}
