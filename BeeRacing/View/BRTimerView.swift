//
//  BRTimerView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 09/11/2024.
//

import SwiftUI

struct BRTimerView: View {
    var body: some View {
        ZStack(alignment: .center) {
            BackgroundView(bgColor: .black)
                .ignoresSafeArea()
            VStack {
                Text("Time remaining")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("00:00")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 4)
    }
}

struct BackgroundView: View {
    var bgColor: Color
    
    var body: some View {
        Color(bgColor).frame(minWidth: 0)
    }
}

#Preview {
    BRTimerView()
}
