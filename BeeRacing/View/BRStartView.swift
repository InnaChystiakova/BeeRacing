//
//  ContentView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import SwiftUI

struct BRStartView: View {
    @StateObject var viewModel = BRViewModel()
    @State private var errorMessage: String?

    private let buttonWidth: CGFloat = 190
    private let buttonHeight: CGFloat = 65
    private let buttonTitle: String = "Start Bee Racing"
    
    var body: some View {
        VStack {
            Button(buttonTitle) {
                Task {
                    await viewModel.getTimer()
                }
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment:.center)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .alert(isPresented: .constant(errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
        .onReceive(viewModel.$timerData) { timerData in
            if let timerData = timerData {
                print ("Timer data: \(timerData)")
            }
        }
        .onReceive(viewModel.$error) { error in
            errorMessage = error
        }
    }
}

#Preview {
    BRStartView()
}
