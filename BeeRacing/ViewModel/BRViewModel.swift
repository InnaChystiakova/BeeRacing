//
//  BRViewModel.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

class BRViewModel: ObservableObject {
    //MARK: - Private APIs
    private let timerAPIURLString = "https://rtest.proxy.beeceptor.com/bees/race/duration"
    private let raceAPIURLString = "https://rtest.proxy.beeceptor.com/bees/race/status"
    
    //MARK: - Variables
    @Published var error: String?
    @Published var isRaceStarted = false
    
    var timerData: Int?
    private var raceTimer: Timer?
    
    //MARK: - Session Client
    private let sessionClient: BRSessionClient

    init(sessionClient: BRSessionClient = BRSessionClient()) {
        self.sessionClient = sessionClient
    }
    
    //MARK: - VM Methods
    
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
    
    func startRace() {
        resetTimer()
        raceTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        raceTimer?.invalidate()
        raceTimer = nil
    }
    
    @objc private func startCountdown() {
        guard let timeRemaining = timerData, timeRemaining > 0 else {
            resetTimer()
            isRaceStarted = false
            print("Finished")
            return
        }
        
        DispatchQueue.main.async {
            self.timerData = timeRemaining - 1
        }
    }
}
