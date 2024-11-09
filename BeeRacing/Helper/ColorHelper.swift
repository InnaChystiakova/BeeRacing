//
//  ColorHelper.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import SwiftUI

extension Color {
    static func colorFromHex(hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        if hexSanitized.count == 6 {
            let scanner = Scanner(string: hexSanitized)
            var hexValue: UInt64 = 0
            if scanner.scanHexInt64(&hexValue) {
                let red = Double((hexValue & 0xFF0000) >> 16) / 255.0
                let green = Double((hexValue & 0x00FF00) >> 8) / 255.0
                let blue = Double(hexValue & 0x0000FF) / 255.0
                return Color(red: red, green: green, blue: blue)
            }
        }
        
        return Color.white
    }
}
