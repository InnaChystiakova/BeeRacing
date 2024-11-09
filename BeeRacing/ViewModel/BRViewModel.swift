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
            showErrorWithDescription(description: BRSessionError.badURL.localizedDescription)
            return
        }
        
        do {
            let result = try await sessionClient.performRequest(from: url)
            let timerData = try JSONDecoder().decode(BRTimer.self, from: result.data)
            DispatchQueue.main.async {
                self.timerData = timerData.timeInSeconds
                self.isRaceStarted = true
            }
        } catch {
            alertUI(with: error)
        }
    }
    
    func updateBeePositions() async {
        guard let url = URL(string: raceAPIURLString) else {
            showErrorWithDescription(description: BRSessionError.badURL.localizedDescription)
            return
        }
        
        do {
            let result = try await sessionClient.performRequest(from: url)
            let viewModelResult = try BRValidator.handleJSON(with: result)
            
            switch viewModelResult {
            case let .bee(beeList):
                DispatchQueue.main.async {
                    self.beeList = beeList
                }
            case let .captcha(captcha):
                DispatchQueue.main.async {
                    print("Captcha!!!")             // show captcha web view
                }
            case let .beeError(error):
                DispatchQueue.main.async {
                    print("Bee Error!!!")           // show error screen
                }
            }
        } catch {
            alertUI(with: error)
        }
    }
    
    private func alertUI(with error: Error) {
        guard let brError = error as? BRSessionError else {
            showErrorWithDescription(description: error.localizedDescription)
            return
        }
        
        showErrorWithDescription(description: brError.localizedDescription)
    }
    
    private func showErrorWithDescription(description: String) {
        DispatchQueue.main.async {
            self.error = description
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
