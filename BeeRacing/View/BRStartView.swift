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

    var body: some View {
        NavigationStack {
            VStack {
                Button("Start Bee Racing") {
                    Task {
                        await viewModel.getTimer()
                    }
                }
                .frame(width: 190, height: 65, alignment:.center)
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
            .navigationDestination(isPresented: $viewModel.isRaceStarted) {
                BRRaceView(viewModel: viewModel)
            }
            .onReceive(viewModel.$error) { error in
                errorMessage = error
            }
        }
    }
}

#Preview {
    BRStartView()
}
