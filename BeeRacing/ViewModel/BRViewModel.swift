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
    @Published var beeList: [BRBee] = []
    
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
            let result = try await sessionClient.performRequest(from: url)
            let timerData = try JSONDecoder().decode(BRTimer.self, from: result.data)
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
    
    func updateBeePositions() async {
        guard let url = URL(string: raceAPIURLString) else {
            DispatchQueue.main.async {
                self.error = BRSessionError.badURL.localizedDescription
            }
            return
        }
        
        do {
            let result = try await sessionClient.performRequest(from: url)
            let beeStatus = try BRBeeMapper.map(result.data, from: result.response as! HTTPURLResponse)
            DispatchQueue.main.async {
                self.beeList = beeStatus
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
    
    //MARK: - Timer Methods
    
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
            return
        }
        
        DispatchQueue.main.async {
            self.timerData = timeRemaining - 1
        }
        
        Task {
            await self.updateBeePositions()
        }
    }
}
