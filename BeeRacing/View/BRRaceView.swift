//
//  BRRaceView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import SwiftUI

struct BRRaceView: View {
    @ObservedObject var viewModel: BRViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            BRTimerView()
            List(viewModel.beeList) { bee in
                HStack {
                    Circle()
                        .fill(Color.colorFromHex(hex: bee.color))
                        .frame(width: 40, height: 40)
                    Text(bee.name)
                        .font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("\(Image(systemName: "chevron.left"))")
                            .foregroundStyle(.white)
                    }
                }
            }
            .ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
            .task {
                viewModel.startRace()
            }
        }
        .sheet(isPresented: $viewModel.showCaptcha) {
            if let url = viewModel.captchaURL {
                BRCaptchWebView(url: url)
            }
        }
    }
}

struct BRRaceView_Previews: PreviewProvider {
    static var previews: some View {
        BRRaceView(viewModel: previewViewModel)
    }
    
    static var previewViewModel: BRViewModel {
        let viewModel = BRViewModel()
        
        viewModel.timerData = 10
        viewModel.beeList = [
            BRBee(name: "BeeGees", color: "#8d62a1"),
            BRBee(name: "BuzzLightyear", color: "#ffcc00")
        ]
        
        return viewModel
    }
}
