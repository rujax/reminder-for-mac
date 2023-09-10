//
//  NoRepeatTab.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct NoRepeatTab: View {
    @Binding var reminder: Reminder

    @State private var title: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    @State private var time: (
        yearMonthDay: String, hour: String, minute: String, second: String
    ) = (
        "", "00", "00", "00"
    )

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("标题").frame(height: 40)
            TextField("请输入标题", text: $title)
                .onChange(of: title) { newTitle in
                    reminder.title = newTitle
                }
                .focused($isTitleFocused)

            Text("指定日期时间").frame(height: 40)

            HStack(alignment: .top, spacing: 0) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: selectedDate...,
                    displayedComponents: .date
                )
                .datePickerStyle(.field)
                .labelsHidden()
                .padding(.trailing, 10)
                .frame(width: 220, height: 22, alignment: .top)
                .fixedSize()
                .clipped()
                .onChange(of: selectedDate) { date in
                    time.yearMonthDay = formatDate(date, "yyyy-MM-dd")

                    reminder.time = "\(time.yearMonthDay) \(time.hour):\(time.minute):\(time.second)"
                }

                Picker("", selection: $selectedHour) {
                    ForEach(0..<24) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .frame(width: 60)
                .onChange(of: selectedHour) { hour in
                    time.hour = String(format: "%02d", hour)

                    reminder.time = "\(time.yearMonthDay) \(time.hour):\(time.minute):\(time.second)"
                }

                Text(":").frame(width: 16)

                Picker("", selection: $selectedMinute) {
                    ForEach(0..<60) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .frame(width: 60)
                .onChange(of: selectedMinute) { minute in
                    time.minute = String(format: "%02d", minute)

                    reminder.time = "\(time.yearMonthDay) \(time.hour):\(time.minute):\(time.second)"
                }

                Text(":").frame(width: 16)

                Picker("", selection: $selectedSecond) {
                    ForEach(0..<60) { i in
                        Text("\(String(format: "%02d", i))")
                    }
                }
                .labelsHidden()
                .frame(width: 60)
                .onChange(of: selectedSecond) { second in
                    time.second = String(format: "%02d", second)

                    reminder.time = "\(time.yearMonthDay) \(time.hour):\(time.minute):\(time.second)"
                }
            }

            Text("是否启用").frame(height: 40)

            Button {
                reminder.toggleStatus()
            } label: {
                Image(reminder.isEnabled() ? "SwitchOn" : "SwitchOff")
                    .frame(width: 33, height: 20)
            }
            .buttonStyle(.borderless)

            Spacer()
        }
        .padding(10)
        .onAppear() {
            print("NoReapeatTab onAppear")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isTitleFocused = true
            }

            title = reminder.title
            time = reminder.parseTime()

            selectedDate = generateDate(reminder.time)
            selectedHour = Int(time.hour) ?? 0
            selectedMinute = Int(time.minute) ?? 0
            selectedSecond = Int(time.second) ?? 0
        }
    }
}
