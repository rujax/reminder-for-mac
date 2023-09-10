//
//  ReminderDialog.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct ReminderDialog: View {
    @AppStorage("NoRepeatReminders") var noRepeatReminders: [Reminder] = []
    @AppStorage("HourlyReminders") var hourlyReminders: [Reminder] = []
    @AppStorage("DailyReminders") var dailyReminders: [Reminder] = []
    @AppStorage("WeeklyReminders") var weeklyReminders: [Reminder] = []
    @AppStorage("MonthlyReminders") var monthlyReminders: [Reminder] = []

    @Binding var isShowingReminderDialog: Bool
    @Binding var reminder: Reminder

    @State private var selection: Int = 0
    @State private var noRepeatReminder: Reminder = Reminder(repeatMode: .noRepeat)
    @State private var hourlyReminder: Reminder = Reminder(repeatMode: .hourly)
    @State private var dailyReminder: Reminder = Reminder(repeatMode: .daily)
    @State private var weeklyReminder: Reminder = Reminder(repeatMode: .weekly)
    @State private var monthlyReminder: Reminder = Reminder(repeatMode: .monthly)
    @State private var isShowingAlert: Bool = false

    init(isShowingReminderDialog: Binding<Bool>, reminder: Binding<Reminder>) {
        print("ReminderDialog init()")

        self._isShowingReminderDialog = isShowingReminderDialog
        self._reminder = reminder
    }

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                NoRepeatTab(reminder: $noRepeatReminder)
                    .tabItem {
                        Label("不重复", systemImage: "calendar")
                    }
                    .tag(0)

                HourlyTab(reminder: $hourlyReminder)
                    .tabItem {
                        Label("每小时", systemImage: "sun.max")
                    }
                    .tag(1)

                DailyTab(reminder: $dailyReminder)
                    .tabItem {
                        Label("每天", systemImage: "moon")
                    }
                    .tag(2)

                WeeklyTab(reminder: $weeklyReminder)
                    .tabItem {
                        Label("每周", systemImage: "sparkle")
                    }
                    .tag(3)

                MonthlyTab(reminder: $monthlyReminder)
                    .tabItem {
                        Label("每月", systemImage: "cloud")
                    }
                    .tag(4)
            }
            HStack() {
                Button("确定") {
                    print("selection", selection)

                    switch selection {
                    case 0:
                        if reminder.repeatMode != noRepeatReminder.repeatMode {
                            if let index = noRepeatReminders.firstIndex(where: { $0.id == reminder.id }) {
                                noRepeatReminders.remove(at: index)
                            }
                        }

                        reminder = noRepeatReminder

                    case 1:
                        if reminder.repeatMode != hourlyReminder.repeatMode {
                            hourlyReminders = hourlyReminders.filter { $0.id != reminder.id }
                        }

                        reminder = hourlyReminder

                    case 2:
                        if reminder.repeatMode != dailyReminder.repeatMode {
                            dailyReminders = dailyReminders.filter { $0.id != reminder.id }
                        }

                        reminder = dailyReminder

                    case 3:
                        if reminder.repeatMode != weeklyReminder.repeatMode {
                            weeklyReminders = weeklyReminders.filter { $0.id != reminder.id }
                        }

                        reminder = weeklyReminder

                    case 4:
                        if reminder.repeatMode != monthlyReminder.repeatMode {
                            monthlyReminders = monthlyReminders.filter { $0.id != reminder.id }
                        }

                        reminder = monthlyReminder

                    default:
                        break
                    }

                    print(reminder)

                    if reminder.title.isEmpty {
                        isShowingAlert = true

                        return
                    }

                    if reminder.id == "" {
                        reminder.id = UUID().uuidString

                        switch reminder.repeatMode {
                        case .noRepeat:
                            noRepeatReminders.append(reminder)

                        case .hourly:
                            hourlyReminders.append(reminder)

                        case .daily:
                            dailyReminders.append(reminder)

                        case .weekly:
                            weeklyReminders.append(reminder)

                        case .monthly:
                            monthlyReminders.append(reminder)
                        }
                    }

                    switch reminder.repeatMode {
                    case .noRepeat:
                        noRepeatReminders.sort {
                            $0.time < $1.time
                        }

                    case .hourly:
                        hourlyReminders.sort {
                            $0.time < $1.time
                        }

                    case .daily:
                        dailyReminders.sort {
                            $0.time < $1.time
                        }

                    case .weekly:
                        weeklyReminders.sort {
                            $0.time < $1.time
                        }

                    case .monthly:
                        monthlyReminders.sort {
                            $0.time < $1.time
                        }
                    }

                    isShowingReminderDialog.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("取消") {
                    isShowingReminderDialog.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(10)
        .frame(width: 480, height: 420)
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("请填写标题"))
        }
        .onAppear() {
            print("ReminderDialog onAppear")

            selection = reminder.repeatMode.rawValue

            switch selection {
            case 0:
                noRepeatReminder = reminder
            case 1:
                hourlyReminder = reminder
            case 2:
                dailyReminder = reminder
            case 3:
                weeklyReminder = reminder
            case 4:
                monthlyReminder = reminder
            default:
                break
            }
        }
    }
}
