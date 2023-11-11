//
//  ReminderView.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI
import Combine
import UserNotifications

struct ReminderView: View {
    @AppStorage("NoRepeatReminders") var noRepeatReminders: [Reminder] = []
    @AppStorage("HourlyReminders") var hourlyReminders: [Reminder] = []
    @AppStorage("DailyReminders") var dailyReminders: [Reminder] = []
    @AppStorage("WeeklyReminders") var weeklyReminders: [Reminder] = []
    @AppStorage("MonthlyReminders") var monthlyReminders: [Reminder] = []

    @Binding var reminder: Reminder

    @State private var isConfirming = false
    @State private var isShowingReminderDialog = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }

    func updateReminder() {
        stopTimer()

        if reminder.isEnabled() {
            startTimer()
        }

        switch reminder.repeatMode {
        case .noRepeat:
            for index in noRepeatReminders.indices {
                if noRepeatReminders[index].id == reminder.id {
                    noRepeatReminders[index] = reminder

                    break
                }
            }

        case .hourly:
            for index in hourlyReminders.indices {
                if hourlyReminders[index].id == reminder.id {
                    hourlyReminders[index] = reminder

                    break
                }
            }

        case .daily:
            for index in dailyReminders.indices {
                if dailyReminders[index].id == reminder.id {
                    dailyReminders[index] = reminder

                    break
                }
            }

        case .weekly:
            for index in weeklyReminders.indices {
                if weeklyReminders[index].id == reminder.id {
                    weeklyReminders[index] = reminder

                    break
                }
            }

        case .monthly:
            for index in monthlyReminders.indices {
                if monthlyReminders[index].id == reminder.id {
                    monthlyReminders[index] = reminder

                    break
                }
            }
        }
    }

    func deleteReminder() {
        stopTimer()

        switch reminder.repeatMode {
        case .noRepeat:
            noRepeatReminders.removeAll(where: { $0.id == reminder.id })
        case .hourly:
            hourlyReminders.removeAll(where: { $0.id == reminder.id })
        case .daily:
            dailyReminders.removeAll(where: { $0.id == reminder.id })
        case .weekly:
            weeklyReminders.removeAll(where: { $0.id == reminder.id })
        case .monthly:
            monthlyReminders.removeAll(where: { $0.id == reminder.id })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    Image(reminder.isEnabled() ? "Enabled" : "Disabled")
                        .frame(width: 48, height: 48)
                }
                .frame(width: 80, height: 79.5)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(reminder.title)
                            .bold()
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: 0x333333))
                        Spacer()
                        Button {
                            isConfirming = true
                        } label: {
                            Image("Remove").frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .confirmationDialog("确认删除提醒？", isPresented: $isConfirming) {
                            Button {
                                deleteReminder()
                            } label: {
                                Text("删除")
                            }

                            Button("取消", role: .cancel) {

                            }
                        }
                    }

                    Spacer()

                    HStack(spacing: 0) {
                        Text("重复")
                            .foregroundColor(Color(hex: 0x444444))
                            .frame(width: 30, alignment: .leading)
                        Text(reminder.repeatText())
                            .foregroundColor(Color(hex: 0x009966))
                            .frame(width: 60, alignment: .leading)

                        Text("时间")
                            .foregroundColor(Color(hex: 0x444444))
                            .frame(width: 30, alignment: .leading)
                        Text(reminder.time)
                            .foregroundColor(Color(hex: 0x009966))
                            .frame(minWidth: 60, alignment: .leading)

                        if reminder.repeatMode == .hourly {
                            Text("免打扰")
                                .foregroundColor(Color(hex: 0x444444))
                                .frame(width: 45, alignment: .leading)

                            Text(reminder.dnd == .openDND ? reminder.dndDuration : "未开启")
                                .foregroundColor(Color(hex: 0x009966))
                                .frame(minWidth: 60, alignment: .leading)
                        }

                        Spacer()

                        Button {
                            reminder.toggleStatus()
                            updateReminder()
                        } label: {
                            Image(reminder.isEnabled() ? "SwitchOn" : "SwitchOff")
                                .frame(width: 33, height: 20)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .padding([.top, .trailing, .bottom], 15)
                .frame(width: 520, height: 79.5)
            }
            .frame(width: 600, height: 79.5)
            .background(reminder.isEnabled() ? Color(hex: 0xeeeeee) : Color(hex: 0xcccccc))
            .gesture(TapGesture().onEnded {
                isShowingReminderDialog = true
            })
            .sheet(isPresented: $isShowingReminderDialog) {
                ReminderDialog(
                    isShowingReminderDialog: $isShowingReminderDialog,
                    reminder: $reminder
                )
            }

            HStack(spacing: 0) {}.frame(width: 600, height: 1).background(.gray)
        }
        .onAppear() {
            print("ReminderView onAppear")

            if reminder.isEnabled() {
                startTimer()
            }
        }
        .onReceive(timer) { now in
            if !reminder.isEnabled() {
                return
            }

            var isTimeout: Bool = false

            switch reminder.repeatMode {
            case .noRepeat:
                isTimeout = reminder.time == formatDate(now)

            case .hourly:
                if reminder.isOpenDND() {
                    let dndDuration: [String] = reminder.dndDuration.components(separatedBy: " ~ ")
                    let dndStart: String = dndDuration[0] + "00分00秒"
                    let dndEnd: String = dndDuration[1] + "00分00秒"

                    if dndEnd > dndStart &&
                        formatDate(now, "HH点mm分ss秒") >= dndStart && formatDate(now, "HH点mm分ss秒") < dndEnd {
                        break
                    }

                    if dndEnd < dndStart &&
                        (formatDate(now, "HH点mm分ss秒") >= dndStart || formatDate(now, "HH点mm分ss秒") < dndEnd) {
                        break
                    }
                }

                isTimeout = (reminder.time + "00秒") == formatDate(now, "mm分ss秒")

            case .daily:
                isTimeout = (reminder.time + "00秒") == formatDate(now, "HH点mm分ss秒")

            case .weekly:
                isTimeout = (reminder.time + "00秒") == now.weekDay() + formatDate(now, "HH点mm分ss秒")

            case .monthly:
                isTimeout = (reminder.time + "00秒") == formatDate(now, "dd号HH点mm分ss秒")
            }

            if isTimeout {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        let content = UNMutableNotificationContent()
                        content.title = "您有一条新的提醒"
                        content.subtitle = reminder.title
                        content.sound = .default

                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

                        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                            content: content,
                                                            trigger: trigger)

                        UNUserNotificationCenter.current().add(request) { error in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                            }
                        }
                    }
                }
            }

            if reminder.isEnabled() && reminder.repeatMode == .noRepeat && reminder.time < formatDate(now) {
                reminder.status = .disabled
                updateReminder()
            }
        }
        .onChange(of: reminder) { newReminder in
            newReminder.isEnabled() ? startTimer() : stopTimer()
        }
    }
}
