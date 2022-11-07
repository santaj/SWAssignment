//
//  Movies.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation

public struct Film: Decodable, Equatable, Hashable {
    public let title: String
    public let episodeId: Int
    public let openingCrawl: String
    public let director: String
    public let producer: String
    public let releaseDate: String
    public let species: [String]
    public let starships: [String]
    public let vehicles: [String]
    public let characters: [String]
    public let planets: [String]
    public let url: String
    public let created: Date
    public let edited: Date

  enum CodingKeys: String, CodingKey {
    case title
    case episodeId = "episode_id"
    case openingCrawl = "opening_crawl"
    case director
    case producer
    case releaseDate = "release_date"
    case species
    case starships
    case vehicles
    case characters
    case planets
    case url
    case created
    case edited
  }
}
