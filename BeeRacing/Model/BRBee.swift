//
//  BRBee.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public struct BRBee: Decodable, Identifiable {
    public let id: UUID
    public let name: String
    public let color: String
    
    public init(name: String, color: String) {
        self.id = UUID()
        self.name = name
        self.color = color
    }
}

struct BeeItem: Decodable {
    let name: String
    let color: String

    var beeItem: BRBee {
        return BRBee(name: name, color: color)
    }
}

class BRBeeMapper {
    private struct Root: Decodable {
        private let beeList: [BeeItem]

        var beeItemsList: [BRBee] {
            return beeList.map { $0.beeItem }
        }
    }
    private init() {}

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [BRBee] {
        guard let bees = try? JSONDecoder().decode(Root.self, from: data) else {
            throw BRSessionError.invalidData
        }

        return bees.beeItemsList
    }
}
