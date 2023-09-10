//
//  Reminder.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import Foundation

enum RepeatMode: Int, Codable {
    case noRepeat   = 0
    case hourly     = 1
    case daily      = 2
    case weekly     = 3
    case monthly    = 4
}

enum Status: Equatable, Codable {
    case enabled
    case disabled
}

enum DND: Codable {
    case closedDND
    case openDND
}

struct Reminder: Identifiable, Codable, Hashable {
    var id: String = ""
    var title: String = ""
    var time: String = currentTime()
    var repeatMode: RepeatMode = .noRepeat
    var status: Status = .enabled
    var dnd: DND = .closedDND
    var dndDuration: String = "00点 ~ 00点"

    init(repeatMode: RepeatMode) {
        print("Reminder init()")

        self.repeatMode = repeatMode

        switch repeatMode {
        case .noRepeat:
            self.time = currentTime()
        case .hourly:
            self.time = "00分"
        case .daily:
            self.time = "00点00分"
        case .weekly:
            self.time = "周一00点00分"
        case .monthly:
            self.time = "01号00点00分"
        }
    }

    func repeatText() -> String {
        switch repeatMode {
        case .noRepeat:
            return "无"
        case .hourly:
            return "每小时"
        case .daily:
            return "每天"
        case .weekly:
            return "每周"
        case .monthly:
            return "每月"
        }
    }

    func isEnabled() -> Bool {
        status == .enabled
    }

    func isOpenDND() -> Bool {
        dnd == .openDND
    }

    mutating func toggleStatus() {
        if (status == .disabled) {
            self.status = .enabled
        } else {
            self.status = .disabled
        }
    }

    mutating func toggleDND() {
        if (dnd == .closedDND) {
            self.dnd = .openDND
        } else {
            self.dnd = .closedDND
        }
    }

    mutating func reset() {
        self.title = ""
        self.time = currentTime()
        self.repeatMode = .noRepeat
        //        self.status = .disabled
        self.dnd = .closedDND
        self.dndDuration = ""
    }

    func parseTime() -> (yearMonthDay: String, hour: String, minute: String, second: String) {
        let times = time.components(separatedBy: " ")
        let hms = times[1].components(separatedBy: ":")

        return (times[0], hms[0], hms[1], hms[2])
    }

    func parseDuration() -> (dndStart: String, dndEnd: String) {
        if dndDuration == "" {
            return ("", "")
        }

        let durations = dndDuration.components(separatedBy: " ~ ")

        return (durations[0], durations[1])
    }
}
