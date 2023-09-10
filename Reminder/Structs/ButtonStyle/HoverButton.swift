//
//  HoverButton.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import SwiftUI

struct HoverButton: ButtonStyle {
    var defaultColor: UInt
    var hoverColor: UInt

    @State var isHover = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.borderless)
            .background(isHover ? Color(hex: hoverColor) : Color(hex: defaultColor))
            .onHover { hover in
                isHover = hover
            }
    }
}
