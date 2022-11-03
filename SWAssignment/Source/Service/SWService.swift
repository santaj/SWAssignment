//
//  DataService.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-31.
//

import Foundation
import Combine

public enum ServiceError: Error {
  case unknown
  case networkError(error: NetworkError)
  case parsingError(error: Error)
}

public protocol SWService {
  func allFilms(page: String?) -> AnyPublisher<ApiResponse<Film>, ServiceError>
  func allPeople(page: String?) -> AnyPublisher<ApiResponse<Person>, ServiceError>

}

public struct DataService: SWService {

  private let dataFetcher = DataFetcher()

  public init() { }

  public func allFilms(page: String?) -> AnyPublisher<ApiResponse<Film>, ServiceError> {
    guard let pageUrl = page else {
      let config = RequestConfiguration(resource: .films)
      return resource(request: Request(config: config))
    }
    return resource(request: Request(resourceUrl: pageUrl))
  }

  public func allPeople(page: String?) -> AnyPublisher<ApiResponse<Person>, ServiceError> {
    guard let pageUrl = page else {
      let config = RequestConfiguration(resource: .people)
      return resource(request: Request(config: config))
    }
    return resource(request: Request(resourceUrl: pageUrl))
  }
    
  private func resources<T: Decodable>(requests: [Request]) -> AnyPublisher<[T], ServiceError> {
    let masterPublisher = Publishers.Sequence<[AnyPublisher<T, ServiceError>], ServiceError>(
      sequence: requests.map(resource(request:))
    )
    return masterPublisher.flatMap { $0 }.collect().eraseToAnyPublisher()
  }

  private func resource<T: Decodable>(request: Request) -> AnyPublisher<T, ServiceError> {
    return dataFetcher.fetch(request.url)
      .mapError { error in
        ServiceError.networkError(error: error)
    }
    .flatMap(maxPublishers: .max(1)) { data in
      decode(data)
    }
    .eraseToAnyPublisher()
  }
}
