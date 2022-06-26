//
//  RequestManager.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

protocol RequestManager {
    func perform<T: Decodable>(_ request: Request) async throws -> T
}


final class RequestManagerImpl: RequestManager {
    let apiManager: APIManager
    let parser: DataParser
    
    init(
        apiManager: APIManager = APIManagerImpl(),
        parser: DataParser = DataParserImpl()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T: Decodable>(_ request: Request) async throws -> T {
        let response: T
        if request.localData {
            response =  try await performLocal(request)
        } else {
            response = try await performRemote(request)
        }
        return response
    }
}

private extension RequestManagerImpl {
    func performRemote<T: Decodable>(_ request: Request) async throws -> T {
        let data = try await apiManager.perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func performLocal<T: Decodable>(_ request: Request) async throws -> T {
        let data = try await apiManager.performLocal(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}
