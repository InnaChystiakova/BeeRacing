//
//  BRError.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 09/11/2024.
//

import Foundation

public struct BRError: Decodable {
    public let code: Int
    public let message: String
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct ErrorItem: Decodable {
    let code: Int
    let message: String

    var errorItem: BRError {
        return BRError(code: code, message: message)
    }
}

class BRErrorMapper {
    private struct Root: Decodable {
        private let error: ErrorItem

        var beeError: BRError {
            return error.errorItem
        }
    }
    private init() {}

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> BRError {
        guard let beeError = try? JSONDecoder().decode(Root.self, from: data) else {
            throw BRSessionError.invalidData
        }

        return beeError.beeError
    }
}
