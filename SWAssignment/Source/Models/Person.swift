//
//  StarWarsPerson.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation

public struct Person: Decodable, Hashable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworldURL: String
    let filmsURLs: [String]
    let species: [String]
    let vehiclesURLs: [String]
    let starshipsURLs: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
        case homeworldURL = "homeworld"
        case filmsURLs = "films"
        case species
        case vehiclesURLs = "vehicles"
        case starshipsURLs = "starships"
        case created
        case edited
        case url
    }
}
