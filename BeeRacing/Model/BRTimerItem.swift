//
//  BRTimerItem.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public typealias BRTimerResult = Swift.Result<BRTimerStruct, Error>

public struct BRTimerStruct: Decodable {
    let timeInSeconds: Int
    
    init(timeInSeconds: Int) {
        self.timeInSeconds = timeInSeconds
    }
}
