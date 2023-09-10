//
//  ContentView.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI
import Combine
import UserNotifications

struct ContentView: View {
    @AppStorage("NoRepeatReminders") var noRepeatReminders: [Reminder] = []
    @AppStorage("HourlyReminders") var hourlyReminders: [Reminder] = []
    @AppStorage("DailyReminders") var dailyReminders: [Reminder] = []
    @AppStorage("WeeklyReminders") var weeklyReminders: [Reminder] = []
    @AppStorage("MonthlyReminders") var monthlyReminders: [Reminder] = []

    @EnvironmentObject private var observableMenu: ObservableMenu
    @Environment(\.openURL) private var openURL

    @State private var isShowingDisableAll: Bool = false
    @State private var isShowingEnableAll: Bool = false
    @State private var isShowingReminderDialog: Bool = false
    @State private var isShowingNotificationDialog: Bool = false

    @State private var newReminder: Reminder = Reminder(repeatMode: .noRepeat)

    func toggleAllReminders(status: Status) {
        for index in noRepeatReminders.indices {
            noRepeatReminders[index].status = status
        }

        for index in hourlyReminders.indices {
            hourlyReminders[index].status = status
        }

        for index in dailyReminders.indices {
            dailyReminders[index].status = status
        }

        for index in weeklyReminders.indices {
            weeklyReminders[index].status = status
        }

        for index in monthlyReminders.indices {
            monthlyReminders[index].status = status
        }
    }

    var body: some View {
        VStack(spacing: 0.0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach($noRepeatReminders, id: \.id) { $noRepeatReminder in
                        ReminderView(reminder: $noRepeatReminder)
                    }

                    ForEach($hourlyReminders, id: \.self) { $hourlyReminder in
                        ReminderView(reminder: $hourlyReminder)
                    }

                    ForEach($dailyReminders, id: \.id) { $dailyReminder in
                        ReminderView(reminder: $dailyReminder)
                    }

                    ForEach($weeklyReminders, id: \.id) { $weeklyReminder in
                        ReminderView(reminder: $weeklyReminder)
                    }

                    ForEach($monthlyReminders, id: \.id) { $monthlyReminder in
                        ReminderView(reminder: $monthlyReminder)
                    }
                }
            }
            .frame(width: 600.0, height: 740.0)

            HStack(spacing: 0.0) {
                Button {
                    isShowingDisableAll = true
                } label: {
                    bottomButtonText(text: "禁用全部提醒")
                }
                .frame(width: 200.0, height: 60.0)
                .buttonStyle(HoverButton(defaultColor: 0x333333, hoverColor: 0x222222))
                .confirmationDialog("确定禁用全部提醒？", isPresented: $isShowingDisableAll) {
                    Button("确定", role: .destructive) {
                        toggleAllReminders(status: .disabled)
                    }
                    Button("取消", role: .cancel) {
                        isShowingDisableAll = false
                    }
                }
                .onChange(of: observableMenu.isDisableAll) { _ in
                    toggleAllReminders(status: .disabled)

                    observableMenu.isDisableAll = false
                }

                Button {
                    newReminder = Reminder(repeatMode: .noRepeat)

                    isShowingReminderDialog.toggle()
                } label: {
                    bottomButtonText(text: "新增提醒")
                }
                .frame(width: 200.0, height: 60.0)
                .buttonStyle(HoverButton(defaultColor: 0x0066ff, hoverColor: 0x0033ff))
                .sheet(isPresented: $isShowingReminderDialog) {
                    ReminderDialog(
                        isShowingReminderDialog: $isShowingReminderDialog,
                        reminder: $newReminder
                    )
                }

                Button {
                    isShowingEnableAll = true

                } label: {
                    bottomButtonText(text: "启用全部提醒")
                }
                .frame(width: 200.0, height: 60.0)
                .buttonStyle(HoverButton(defaultColor: 0x339900, hoverColor: 0x006600))
                .confirmationDialog("确定启用全部提醒？", isPresented: $isShowingEnableAll) {
                    Button("确定", role: .destructive) {
                        toggleAllReminders(status: .enabled)
                    }
                    Button("取消", role: .cancel) {
                        isShowingEnableAll = false
                    }
                }
                .onChange(of: observableMenu.isEnableAll) { _ in
                    toggleAllReminders(status: .enabled)

                    observableMenu.isEnableAll = false
                }
            }
        }
        .frame(width: 600.0, height: 800.0)
        .fixedSize()
        .background(Color(hex: 0xcccccc))
        .onAppear() {
            print("ContentView onAppear")

            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) { authorized, error in
                    if !authorized {
                        print(error?.localizedDescription as Any)

                        isShowingNotificationDialog = true
                    }
                }
        }
        .confirmationDialog("Reminder\n需要允许通知才能正常工作", isPresented: $isShowingNotificationDialog) {
            Button("去设置", role: .destructive) {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications?Privacy_Accessibility") {
                    openURL(url)
                }
            }
            Button("暂不设置", role: .cancel) {

            }
        } message: {
            Text("提醒样式设置为\"提醒\"获得最佳体验")
        }
    }
}

func bottomButtonText(text: String) -> some View {
    Text(text)
        .bold()
        .font(.system(size: 16))
        .foregroundColor(Color.white)
        .frame(width: 200.0, height: 60.0, alignment: .center)
}
