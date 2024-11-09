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
    private let undoCptchaAPIURLString = "https://www.google.com/recaptcha/api2/userverify"
    
    //MARK: - Variables
    @Published var error: String?
    @Published var isRaceStarted = false
    @Published var beeList: [BRBee] = []
    @Published var showCaptcha: Bool = false
    @Published var captchaURL: URL?
    
    var timerData: Int?
    private var raceTimer: Timer?
    
    //MARK: - Session Client
    private let sessionClient: BRSessionClient
    
    init(sessionClient: BRSessionClient = BRSessionClient()) {
        self.sessionClient = sessionClient
    }
    
    //MARK: - View Model Methods
    
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
            
            DispatchQueue.main.async {
                switch viewModelResult {
                case let .bee(beeList):
                    self.beeList = beeList
                case let .captcha(captcha):
                    if let captchaURL = URL(string: captcha.captchaUrl) {
                        self.captchaURL = captchaURL
                        self.showCaptcha = true
                    }
                case let .beeError(error):
                    self.resetTimer()
                    self.alertUI(with: error.message)
                }
            }
        } catch {
            alertUI(with: error)
        }
    }
    
    private func alertUI(with errorDescription: String) {
        showErrorWithDescription(description: errorDescription)
    }
    
    private func alertUI(with systemError: Error) {
        guard let brError = systemError as? BRSessionError else {
            showErrorWithDescription(description: systemError.localizedDescription)
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
        raceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
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
