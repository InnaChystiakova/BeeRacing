//
//  BRSessionClient.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

final class BRSessionClient {
    private let session: BRSessionProtocol
    
    public init(session: BRSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func performRequest(from url: URL) async throws -> BRSessionClientResponse {
        guard let (data, response) = try? await session.get(from: url, delegate: nil) else {
            throw BRSessionError.connectivity
        }
        
        return (data, response)
    }
}
