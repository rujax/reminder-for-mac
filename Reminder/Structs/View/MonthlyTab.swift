//
//  MonthlyTab.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct MonthlyTab: View {
    @Binding var reminder: Reminder

    @State private var title: String = ""
    @State private var selectedDay: Int = 0
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var time: (
        day: String, hour: String, minute: String
    ) = (
        "01号", "00点", "00分"
    )

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text("标题").frame(height: 40)
                TextField("请输入标题", text: $title)
                    .onChange(of: title) { newTitle in
                        reminder.title = newTitle
                    }
                    .focused($isTitleFocused)
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTitleFocused = true
                }
            }

            Group {
                Text("指定天").frame(height: 40)

                Picker("", selection: $selectedDay) {
                    ForEach(1..<32) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .onChange(of: selectedDay) { day in
                    time.day = "\(String(format: "%02d", day + 1))号"

                    reminder.time = "\(time.day)\(time.hour)\(time.minute)"
                }

                Text("指定小时").frame(height: 40)

                Picker("", selection: $selectedHour) {
                    ForEach(0..<24) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .onChange(of: selectedHour) { hour in
                    time.hour = "\(String(format: "%02d", hour))点"

                    reminder.time = "\(time.day)\(time.hour)\(time.minute)"
                }

                Text("指定分钟").frame(height: 40)

                Picker("", selection: $selectedMinute) {
                    ForEach(0..<60) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .onChange(of: selectedMinute) { minute in
                    time.minute = "\(String(format: "%02d", minute))分"

                    reminder.time = "\(time.day)\(time.hour)\(time.minute)"
                }
            }

            Group {
                Text("是否启用").frame(height: 40)

                Button {
                    reminder.toggleStatus()
                } label: {
                    Image(reminder.isEnabled() ? "SwitchOn" : "SwitchOff")
                        .frame(width: 33, height: 20)
                }
                .buttonStyle(.borderless)
            }

            Spacer()
        }
        .padding(10)
        .onAppear() {
            print("MonthlyTab onAppear")

            title = reminder.title

            let timeArray = Array(reminder.time)

            selectedDay = (Int(String(timeArray[0..<2])) ?? 1) - 1
            selectedHour = Int(String(timeArray[3..<5])) ?? 0
            selectedMinute = Int(String(timeArray[6..<8])) ?? 0
        }
    }
}
