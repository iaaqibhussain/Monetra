//
//  Request.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import Foundation

protocol Request {
    var path: String { get }
    var requestType: RequestType? { get }
    var localData: Bool { get }
    var urlParams: [String: String?] { get }
}

// MARK: - Default RequestProtocol
extension Request {
    var host: String {
        ""
    }
    var localData: Bool {
        true
    }
    
    var requestType: RequestType? {
        nil
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { throw  RequestError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType?.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        return urlRequest
    }
}
