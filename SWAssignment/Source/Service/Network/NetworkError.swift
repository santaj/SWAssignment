//
//  NetworkError.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation

public enum NetworkError: Error {
  case apiError(reason: String)
  case badRequest
  case badResponse
  case networkError(from: URLError)
  case unknown

  static func error(withCode code: Int) -> NetworkError {
    switch code {
    case 401:
        return .apiError(reason: "Unauthorized")
    case 403:
        return .apiError(reason: "Resource forbidden")
    case 404:
        return .apiError(reason: "Resource not found")
    case 405..<500:
        return .apiError(reason: "Client error")
    case 500..<600:
        return .apiError(reason: "Server error")
    default:
        return .unknown
    }
  }
}
