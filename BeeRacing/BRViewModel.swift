//
//  BRViewModel.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

class BRViewModel: ObservableObject {
    @Published var timerData: Int?
    @Published var error: String?
    
    private let timerAPIURLString = "https://rtest.proxy.beeceptor.com/bees/race/duration"
    private let sessionClient: BRSessionClient

    init(sessionClient: BRSessionClient = BRSessionClient()) {
        self.sessionClient = sessionClient
    }
    
    func getTimer() async {
        guard let url = URL(string: timerAPIURLString) else {
            DispatchQueue.main.async {
                self.error = BRSessionError.badURL.localizedDescription
            }
            return
        }
        
        do {
            let data = try await sessionClient.performRequest(from: url)
            let timerData = try JSONDecoder().decode(BRTimerStruct.self, from: data)
            DispatchQueue.main.async {
                self.timerData = timerData.timeInSeconds
            }
        } catch let brError as BRSessionError {
            DispatchQueue.main.async {
                self.error = brError.localizedDescription
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }
}
