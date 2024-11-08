//
//  ContentView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import SwiftUI

struct BRStartView: View {
    private let buttonWidth: CGFloat = 190
    private let buttonHeight: CGFloat = 65
    private let buttonTitle: String = "Start Bee Racing"
    
    var body: some View {
        VStack {
            Button(buttonTitle) {
                // start request here
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment:.center)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    BRStartView()
}
