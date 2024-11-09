//
//  BRSessionProtocol.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public enum BRSessionError: Error {
    case badURL
    case connectivity
    case invalidData
    case invalidResponse
}

public typealias BRSessionClientResponse = (data: Data, response: URLResponse)
public typealias BRSessionClientResult = Result<BRSessionClientResponse, Error>

public protocol BRSessionProtocol {
    func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: BRSessionProtocol {
    public func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: delegate)
    }
}
