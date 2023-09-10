//
//  ReminderApp.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

@main
struct ReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @Environment(\.openURL) private var openURL

    var observableMenu: ObservableMenu = ObservableMenu()

    init() {
        print("ReminderApp init()")

        appDelegate.observableMenu = observableMenu
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(observableMenu)
        }
        .commands {
            //            RemindCommands()
            //            SettingCommands()
            //            HelpCommands()
        }
    }
}

struct RemindCommands: Commands {
    var body: some Commands {
        CommandMenu("提醒") {
            Button("新增提醒") {

            }
            Button("启用全部提醒") {

            }
            Button("禁用全部提醒") {

            }
        }
    }
}

struct SettingCommands: Commands {
    var body: some Commands {
        CommandMenu("设置") {
            Button("提醒音效") {

            }
            Button("开机启动") {

            }
        }
    }
}

struct HelpCommands: Commands {
    var body: some Commands {
        CommandMenu("帮助") {
            Button("更新历史") {

            }
        }
    }
}
