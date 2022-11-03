//
//  ResponseModel.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation

public struct ApiResponse<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
