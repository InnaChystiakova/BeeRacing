//
//  BRSessionProtocol.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public enum BRSessionError: Error {
    case connectivity
    case invalidData
    case badURL
}

public typealias BRSessionClientResult = Result<(Data, URLResponse), Error>

public protocol BRSessionProtocol {
    func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: BRSessionProtocol {
    public func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: delegate)
    }
}
