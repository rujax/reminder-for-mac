//
//  Print.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import Foundation

public func print(_ objects: Any...) {
    #if DEBUG
    for (index, object) in objects.enumerated() {
        Swift.print(object, terminator: (index + 1 == objects.count ? "\n" : " "))
    }
    #endif
}

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
