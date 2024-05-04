//
//  MockURLprotocol.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-02.
//

import XCTest
@testable import EnsembleMoviesInOMDB

class MockURLprotocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool { return true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }
    // swiftlint:disable large_tuple
    // MARK: Expected custom response
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?, FetchError?))?
    // swiftlint:enable large_tuple
    // Doesn't matter since we won't cancel request
    override func stopLoading() { }

    // MARK: Custom session with mocked response
    override func startLoading() {
        // Override the handler to give mocked response
        guard let handler = MockURLprotocol.requestHandler else {
            XCTFail("No request handler provided")
            return }

        do {
            let (response, data, error) = try handler(request)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            // Can't send nil data, so sends empty instead
            client?.urlProtocol(self, didLoad: data ?? Data())
            if let error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error handling the request \(error)")
        }
    }
}
