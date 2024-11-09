//
//  BRTimer.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public typealias BRTimerResult = Result<BRTimer, Error>

public struct BRTimer: Decodable {
    let timeInSeconds: Int
    
    init(timeInSeconds: Int) {
        self.timeInSeconds = timeInSeconds
    }
}
