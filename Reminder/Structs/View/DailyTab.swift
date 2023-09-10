//
//  DailyTab.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct DailyTab: View {
    @Binding var reminder: Reminder

    @State private var title: String = ""
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var time: (hour: String, minute: String) = ("00点", "00分")

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("标题").frame(height: 40)
            TextField("请输入标题", text: $title)
                .onChange(of: title) { newTitle in
                    reminder.title = newTitle
                }
                .focused($isTitleFocused)

            Text("指定小时").frame(height: 40)

            Picker("", selection: $selectedHour) {
                ForEach(0..<24) { i in
                    Text("\(String(format: "%02d", i))")
                }
            }
            .labelsHidden()
            .onChange(of: selectedHour) { hour in
                time.hour = "\(String(format: "%02d", hour))点"

                reminder.time = "\(time.hour)\(time.minute)"
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

                reminder.time = "\(time.hour)\(time.minute)"
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
            print("DailyTab onAppear")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleFocused = true
            }

            title = reminder.title

            let timeArray = Array(reminder.time)

            selectedHour = Int(String(timeArray[0..<2])) ?? 0
            selectedMinute = Int(String(timeArray[3..<5])) ?? 0
        }
    }
}
