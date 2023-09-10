//
//  DateExtension.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import Foundation

extension Date {
    func weekDay() -> String {
        let weekDay: Int = Calendar.current.component(.weekday, from: self)

        switch weekDay {
        case 1: return "周日"
        case 2: return "周一"
        case 3: return "周二"
        case 4: return "周三"
        case 5: return "周四"
        case 6: return "周五"
        case 7: return "周六"
        default: return ""
        }
    }
}
