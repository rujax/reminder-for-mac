//
//  Print.swift
//  Reminder
//
//  Created by Rujax on 2023/9/10.
//

import Foundation

public func print(_ objects: Any...) {
    #if DEBUG
    for object in objects {
        Swift.print(object)
    }
    #endif
}

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
