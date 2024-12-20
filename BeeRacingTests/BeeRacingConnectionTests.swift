//
//  BeeRacingConnectionTests.swift
//  BeeRacingTests
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import XCTest
@testable import BeeRacing

final class BeeRacingConnectionTests: XCTestCase {

    func testDoesNotPerformAnyURLRequest() {
        let session = makeSession()
        
        XCTAssertNil(session.url)
    }
    
    func testPerformRequestWithAnyURL() async throws {
        let url = anyURL()
        let session = makeSession()
        
        XCTAssertEqual(session.url, nil, "Precondition: shouldn't have url to start")
        
        _ = try await makeSUT(session: session).performRequest(from: url)
        
        XCTAssertEqual(session.url, url)
    }
    
    func testGetFromURLFailsOnRequestError() async throws {
        let sut = makeSUT(result: .failure(anyNSError()))
        
        do {
            _ = try await sut.performRequest(from: anyURL())
            XCTFail("Expected error: \(BRSessionError.connectivity)")         // prevent false positive result
        } catch {
            XCTAssertEqual(error as? BRSessionError, BRSessionError.connectivity)
        }
    }
    
    func testDeliversDataOn200HTTPResponse() async throws {
        let validData = anyData()
        let validResponse = anyValidURLResponse()
        let sut = makeSUT(result: .success((validData, validResponse)))
        
        let receivedData = try await sut.performRequest(from: anyURL())
        
        XCTAssertEqual(receivedData.data, validData)
        XCTAssertEqual(receivedData.response, validResponse)
    }

    // MARK: -Helpers
    
    private class BRSessionClientStub: BRSessionProtocol {
        private(set) var url: URL? = nil
        
        let result: BRSessionClientResult

        init(result: BRSessionClientResult) {
            self.result = result
        }
        
        func get(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
            self.url = url
            return try result.get()
        }
    }
    
    private func makeSUT(result: BRSessionClientResult) -> BRSessionClient {
        let session = BRSessionClientStub(result: result)
        let sut = BRSessionClient(session: session)
        return sut
    }
    
    private func makeSUT(session: BRSessionClientStub) -> BRSessionClient {
        return BRSessionClient(session: session)
    }
    
    private func makeSession() -> BRSessionClientStub {
        return BRSessionClientStub(result: .success(someValidResponse()))
    }
    
    private func someValidResponse() -> (Data, URLResponse) {
        (anyData(), anyValidURLResponse())
    }
    
    private func anyValidURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://example.com")!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
