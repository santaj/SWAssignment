//
//  DataService.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation
import Combine

struct Request {

  var url: URL? {

    if let resourceId = resourceId {
      return config?.resourceUrl(resourceId: resourceId)
    }

    return config?.resourceRootUrl ?? resourceUrl.flatMap { URL(string: $0) }
  }

  private var resourceUrl: String?

  private var resourceId: String?

  private let config: RequestConfiguration?

  init(
    config: RequestConfiguration? = nil,
    resourceId: String? = nil,
    resourceUrl: String? = nil
  ) {
    self.config = config
    self.resourceId = resourceId
    self.resourceUrl = resourceUrl
  }
}
