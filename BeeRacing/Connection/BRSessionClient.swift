//
//  BRSessionClient.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

class BRSessionClient {
    private let session: BRSessionProtocol
    
    public init(session: BRSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func performRequest(from url: URL) async throws -> Data {
        guard let (data, _) = try? await session.get(from: url, delegate: nil) else {
            throw BRSessionError.connectivity
        }
        
        return data
    }
}
