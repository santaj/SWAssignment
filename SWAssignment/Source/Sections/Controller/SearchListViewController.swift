//
//  SearchListViewController.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import UIKit
import Combine

class SearchListViewController: NiblessViewController {
    
    private var vm: SearchListViewModel
    private var state: State = .idle
    private let searchController = UISearchController(searchResultsController: nil)
    private let loadingView = LoadingView()
    private var films: [Film] = []
    private var filterdFilms: [Film] = []
    private var characters: [Person] = []
    private var filterdCharacters: [Person] = []
    private var selectedCategory: Category = .movies
    private var cancellable: AnyCancellable?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    init(vm: SearchListViewModel) {
        self.vm = vm
        super.init()
        cancellable = vm
            .$state
            .sink { [weak self] in
                self?.updateView(with: $0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Star Wars"
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = Category.allCases.map { $0.description }
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.scopeBarActivation = .onSearchActivation
    }
    
    private func setupSpinner() {
        view.addSubview(loadingView)
        loadingView.setupSpinner()
        loadingView.frame = view.bounds
    }
    
    private func updateView(with state: State) {
        switch state {
        case .idle:
            self.state = .idle
        case .loading:
            self.state = .loading
            setupSpinner()
            searchController.searchBar.isUserInteractionEnabled = false
        case .resultFilms(let result):
            loadingView.removeFromSuperview()
            self.state = .resultFilms(result)
            searchController.searchBar.isUserInteractionEnabled = true
            switch result {
            case .failure(let error):
                showAlertAction(type: .movies, title: "Unable to get movies", message: error.localizedDescription)
            case .success(let result):
                self.films = result
            }
        case .resultPersons(let result):
            loadingView.removeFromSuperview()
            self.state = .resultPersons(result)
            searchController.searchBar.isUserInteractionEnabled = true
            switch result {
            case .failure(let error):
                showAlertAction(type: .characters, title: "Unable to get characters", message: error.localizedDescription)
            case .success(let result):
                self.characters = result
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        switch selectedCategory {
        case .movies:
            filterdFilms = films.filter { films in
                let isMatchingSearchText = films.title.lowercased().contains(searchText.lowercased())
            return isMatchingSearchText
            }
        case .characters:
            filterdCharacters = characters.filter { characters in
                let isMatchingSearchText = characters.name.lowercased().contains(searchText.lowercased())
            return isMatchingSearchText
            }
        }
        tableView.reloadData()
    }
    
    func showAlertAction(type: Category, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            self.handleRetry(type: type)
        }))
        self.present(alert, animated: true)
    }
    
    func handleRetry(type: Category) {
        switch type {
        case .movies:
            vm.getFilms()
        case .characters:
            vm.getCharacters()
        }
    }
}

extension SearchListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .idle, .loading:
            return 0
        case .resultFilms(_):
            return isFiltering ? filterdFilms.count : 0
        case .resultPersons(_):
            return isFiltering ? filterdCharacters.count : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        switch state {
        case .idle, .loading:
            break
        case .resultFilms(_):
            config.text = isFiltering ? filterdFilms[indexPath.row].title : nil
            config.secondaryText = isFiltering ? filterdFilms[indexPath.row].releaseDate : nil
        case .resultPersons(_):
            config.text = isFiltering ? filterdCharacters[indexPath.row].name : nil
        }
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.dismiss(animated: false)
        
        let vc = DetailViewController(category: selectedCategory)
        vc.allCharacters = characters
        vc.allFilms = films
        if selectedCategory == .movies {
            vc.film = self.filterdFilms[indexPath.row]
        }else{
            vc.character = self.filterdCharacters[indexPath.row]
        }
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}

extension SearchListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filterContentForSearchText(text)
        if isSearchBarEmpty && films.isEmpty {
            vm.getFilms()
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchController.searchBar.text?.removeAll()
        selectedCategory = Category.allCases[selectedScope]
        selectedCategory == .movies ? vm.getFilms() : vm.getCharacters()
        filterContentForSearchText(searchBar.text!)
    }
}
