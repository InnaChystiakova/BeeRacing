//
//  BRBee.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

struct BRBee: Codable, Identifiable {
    let id = UUID()
    let name: String
    let color: String
}
