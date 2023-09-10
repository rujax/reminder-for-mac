//
//  HourlyTab.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct HourlyTab: View {
    @Binding var reminder: Reminder

    @State private var title: String = ""
    @State private var selectedMinute: Int = 0
    @State private var selectedDNDStart: Int = 0
    @State private var selectedDNDEnd: Int = 0
    @State private var dndDuration: (dndStart: String, dndEnd: String) = ("00点", "00点")

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("标题").frame(height: 40)
            TextField("请输入标题", text: $title)
                .onChange(of: title) { newTitle in
                    reminder.title = newTitle
                }
                .focused($isTitleFocused)

            Text("指定分钟").frame(height: 40)

            Picker("", selection: $selectedMinute) {
                ForEach(0..<60) { i in
                    Text("\(String(format: "%02d", i))")
                }
            }
            .labelsHidden()
            .onChange(of: selectedMinute) { minute in
                reminder.time = "\(String(format: "%02d分", minute))"
            }

            Text("指定时段启用免打扰").frame(height: 40)

            Button {
                reminder.toggleDND()
            } label: {
                Image(reminder.isOpenDND() ? "SwitchOn" : "SwitchOff")
                    .frame(width: 33, height: 20)
            }
            .buttonStyle(.borderless)

            if reminder.isOpenDND() {
                HStack(spacing: 0) {
                    Picker("", selection: $selectedDNDStart) {
                        ForEach(0..<24) { i in
                            Text("\(String(format: "%02d点", i))")
                        }
                    }
                    .labelsHidden()
                    .onChange(of: selectedDNDStart) { dndStart in
                        dndDuration.dndStart = "\(String(format: "%02d点", dndStart))"

                        reminder.dndDuration = "\(dndDuration.dndStart) ~ \(dndDuration.dndEnd)"
                    }

                    Text("~").frame(width: 20)

                    Picker("", selection: $selectedDNDEnd) {
                        ForEach(0..<24) { i in
                            Text("\(String(format: "%02d点", i))")
                        }
                    }
                    .labelsHidden()
                    .onChange(of: selectedDNDEnd) { dndEnd in
                        dndDuration.dndEnd = "\(String(format: "%02d点", dndEnd))"

                        reminder.dndDuration = "\(dndDuration.dndStart) ~ \(dndDuration.dndEnd)"
                    }
                }
                .frame(height: 30, alignment: .bottom)
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
            print("HourlyTab onAppear")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleFocused = true
            }

            title = reminder.title
            selectedMinute = Int(reminder.time.prefix(2)) ?? 0

            dndDuration = reminder.parseDuration()
            selectedDNDStart = Int(dndDuration.dndStart.prefix(2)) ?? 0
            selectedDNDEnd = Int(dndDuration.dndEnd.prefix(2)) ?? 0
        }
    }
}
