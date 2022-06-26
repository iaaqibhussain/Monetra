//
//  RequestError.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import Foundation

public enum RequestError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    case couldnotParse
    case generic(Error)
    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .couldnotParse:
            return "Unable to parse the JSON."
        case let .generic(error):
            return error.localizedDescription
        }
    }
}
