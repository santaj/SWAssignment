//
//  NetworkManager.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation
import Combine

struct DataFetcher {
  private let sharedSession = URLSession.shared

  func fetch(_ url: URL?) -> AnyPublisher<Data, NetworkError> {
    guard let url = url else {
      return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
    }

    let request = URLRequest(url: url)
    return sharedSession.dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw NetworkError.badResponse
        }
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 300 else {
          throw NetworkError.error(withCode: httpResponse.statusCode)
        }

        return data
      }
    .mapError { error in
      if let networkError = error as? NetworkError {
        return networkError
      }
      if let urlError = error as? URLError {
        return NetworkError.networkError(from: urlError)
      }

      return NetworkError.unknown
    }
    .eraseToAnyPublisher()
  }
}
