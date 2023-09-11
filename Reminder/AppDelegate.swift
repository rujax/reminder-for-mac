//
//  AppDelegate.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI
import UserNotifications
import ServiceManagement

//import LaunchAtLogin

@objc
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var observableMenu: ObservableMenu?

    private var statusItem: NSStatusItem!
    private var launchMenuItem: NSMenuItem!

//    private var isLaunchedAtLogin: Bool {
//        guard let event = NSAppleEventManager.shared().currentAppleEvent else { return false }
//
//        return
//            event.eventID == kAEOpenApplication &&
//            event.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
//    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("applicationDidFinishLaunching")

        let mainWindow = NSApp.windows[0]
        mainWindow.delegate = self

        UNUserNotificationCenter.current().delegate = self

        if let m = NSApp.mainMenu?.item(withTitle: "File") {
            NSApp.mainMenu?.removeItem(m)
        }

        if let m = NSApp.mainMenu?.item(withTitle: "Edit") {
            NSApp.mainMenu?.removeItem(m)
        }

        if let m = NSApp.mainMenu?.item(withTitle: "View") {
            NSApp.mainMenu?.removeItem(m)
        }

        if let m = NSApp.mainMenu?.item(withTitle: "Window") {
            NSApp.mainMenu?.removeItem(m)
        }

        if let m = NSApp.mainMenu?.item(withTitle: "Help") {
            NSApp.mainMenu?.removeItem(m)
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusIcon")
        }

        let menu = NSMenu(title: "Reminder")
        menu.addItem(withTitle: "打开主面板", action: #selector(AppDelegate.openMainWindow), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "启用全部提醒", action: #selector(AppDelegate.enableAllReminders), keyEquivalent: "")
        menu.addItem(withTitle: "禁用全部提醒", action: #selector(AppDelegate.disableAllReminders), keyEquivalent: "")
        menu.addItem(.separator())

//        launchMenuItem = NSMenuItem(title: "开机启动", action: #selector(AppDelegate.setLaunchAtLogin), keyEquivalent: "")
//        launchMenuItem.state = LaunchAtLogin.isEnabled ? .on : .off
//        menu.addItem(launchMenuItem)
//        menu.addItem(.separator())

        menu.addItem(withTitle: "退出", action: #selector(AppDelegate.quit), keyEquivalent: "")

        statusItem.menu = menu

//        if isLaunchedAtLogin {
//            NSApp.hide(self)
//            NSApp.setActivationPolicy(.accessory)
//        }

//        var startedAtLogin = false
//
//        for app in NSWorkspace.shared.runningApplications {
//            if app.bundleIdentifier == "org.rujax.Reminder" {
//                startedAtLogin = true
//
//                break
//            }
//        }
//
//        print("startedAtLogin", startedAtLogin)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        print("applicationShouldTerminate")

        if NSApp.activationPolicy() == .accessory {
            return .terminateNow
        }

        NSApp.hide(self)
        NSApp.setActivationPolicy(.accessory)

        return .terminateCancel
    }

    func windowWillClose(_ notification: Notification) {
        print("windowWillClose")
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("windowShouldClose")

        NSApp.hide(self)
        NSApp.setActivationPolicy(.accessory)

        return false
    }

    @objc func openMainWindow() {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func enableAllReminders() {
        observableMenu?.isEnableAll = true
    }

    @objc func disableAllReminders() {
        observableMenu?.isDisableAll = true
    }

//    @objc func setLaunchAtLogin() {
//        print(LaunchAtLogin.isEnabled)
//
//        LaunchAtLogin.isEnabled.toggle()
//        launchMenuItem.state = LaunchAtLogin.isEnabled ? .on : .off
//    }

    @objc func quit() {
        NSApp.hide(self)
        NSApp.setActivationPolicy(.accessory)
        NSApplication.shared.terminate(self)
    }
}
