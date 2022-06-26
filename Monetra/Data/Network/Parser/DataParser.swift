//
//  DataParser.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import Foundation

protocol DataParser {
  func parse<T: Decodable>(data: Data) throws -> T
}

class DataParserImpl: DataParser {
  private var jsonDecoder: JSONDecoder

  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func parse<T: Decodable>(data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}
