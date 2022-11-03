//
//  SearchListVM.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import Foundation
import Combine

enum State {
    case idle
    case loading
    case resultFilms(Result<[Film], ServiceError>)
    case resultPersons(Result<[Person], ServiceError>)
}

enum Category: String, CaseIterable {
  case movies
  case characters
    
    var description: String {
        switch self {
        case .movies:
            return "Movies"
        case .characters:
            return "Characters"
        }
    }
}

final class SearchListViewModel {
    
    private let dataService: SWService
    private var disposables = Set<AnyCancellable>()
    
    @Published private(set) var state: State = .idle
    
    init(dataService: SWService) {
        self.dataService = dataService
        getCharacters()
    }
    
    private func loadFilms(completion: @escaping (Result<[Film], ServiceError>) -> Void) {
        dataService.allFilms(page: nil)
          .map { response in
              response.results
              .sorted(by: { film1, film2 in
                film1.releaseDate < film2.releaseDate
              })
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {
          switch $0 {
          case .failure(let error):
              completion(.failure(error))
          case .finished:
            break
          }
        }, receiveValue: { films in
            completion(.success(films))
        })
          .store(in: &disposables)
      }
    
    private func loadPersons(completion: @escaping (Result<[Person], ServiceError>) -> Void) {
        dataService.allPeople(page: nil)
        .map { response -> [Person] in
            response.results
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {
          switch $0 {
          case .failure(let error):
              completion(.failure(error))
          case .finished:
            break
          }
        }, receiveValue: { persons in
            completion(.success(persons))
        })
          .store(in: &disposables)
      }
    
    func getFilms() {
        state = .loading
        loadFilms { [weak self] in
            self?.state = .resultFilms($0)
        }
    }

    func getCharacters() {
        state = .loading
        loadPersons { [weak self] in
            self?.state = .resultPersons($0)
        }
    }
}
