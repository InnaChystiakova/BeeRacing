//
//  BRRaceView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import SwiftUI

struct BRRaceView: View {
    @ObservedObject var viewModel: BRViewModel
    
    var body: some View {
        VStack {
            List(viewModel.beeList) { bee in
                HStack {
                    Text(bee.name)
                        .font(.headline)
                    Circle()
                        .fill(Color.colorFromHex(hex: bee.color))
                        .frame(width: 20, height: 20)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarBackButtonHidden(true)
            .task {
                viewModel.startRace()
            }
        }
    }
}
