//
//  BRViewModel.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

class BRViewModel: ObservableObject {
    @Published var error: String?
    
    var isRaceStarted = false
    var timerData: Int?
    
    private let timerAPIURLString = "https://rtest.proxy.beeceptor.com/bees/race/duration"
    private let raceAPIURLString = "https://rtest.proxy.beeceptor.com/bees/race/status"
    
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
            let timerData = try JSONDecoder().decode(BRTimer.self, from: data)
            DispatchQueue.main.async {
                self.timerData = timerData.timeInSeconds
                self.isRaceStarted = true
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
