//
//  BeeRacingConnectionTests.swift
//  BeeRacingTests
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import XCTest

protocol BRSessionProtocol {
}

extension URLSession: BRSessionProtocol {
    
}

class BeeRacingSessionClient: BRSessionProtocol {
    private let session: BRSessionProtocol
    
    public init(session: BRSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

final class BeeRacingConnectionTests: XCTestCase {

    func testDoesNotPerformAnyURLRequest() {
        let session = makeSession()
        
        XCTAssertNil(session.url)
    }

    // MARK: -Helpers
    
    private class BeeRacingConnectionStub: BRSessionProtocol {
        private(set) var url: URL? = nil
    }
    
    private func makeSession() -> BeeRacingConnectionStub {
        return BeeRacingConnectionStub()
    }
}
