//
//  APIManager.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import Foundation

protocol APIManager {
    func perform(_ request: Request) async throws -> Data
    func performLocal(_ request: Request) async throws -> Data
}

class APIManagerImpl: APIManager {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: Request) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)  else { throw RequestError.invalidServerResponse }
        return data
    }
    
    func performLocal(_ request: Request) async throws -> Data {
        if let path = Bundle.main.path(forResource: request.path, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch {
                throw RequestError.generic(error)
            }
        }
        throw RequestError.couldnotParse
    }
}
