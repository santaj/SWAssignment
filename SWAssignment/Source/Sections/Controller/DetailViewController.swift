//
//  ResultViewController.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-11-02.
//

import UIKit

class DetailViewController: NiblessViewController {
    
    public var allCharacters: [Person]?
    public var allFilms: [Film]?
    private var category: Category
    private var allCharactersResultInFilm = [Person]()
    private var allFilmsResultForCharacter = [Film]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    public var film: Film? {
        didSet {
            setupView(for: .movies)
        }
    }
    
    public var character: Person? {
        didSet {
            setupView(for: .characters)
        }
    }
    
    init(category: Category) {
        self.category = category
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
    }
    
    private func setupView(for type: Category) {
        switch type {
        case .movies:
            title = film?.title
            film?.characters.forEach({ character in
                if let exist = allCharacters?.filter({$0.url == character}).first {
                    allCharactersResultInFilm.append(exist)
                }
            })
        case .characters:
            title = character?.name
            character?.filmsURLs.forEach({ filmURL in
                if let exist = allFilms?.filter({$0.url == filmURL}).first {
                    allFilmsResultForCharacter.append(exist)
                }
            })
        }
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
        tableView.allowsSelection = false
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch category {
        case .movies:
            return allCharactersResultInFilm.count > 0 ? allCharactersResultInFilm.count : 1
        case .characters:
            return allFilmsResultForCharacter.count > 0 ? allFilmsResultForCharacter.count : 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        switch category {
        case .movies:
            allCharactersResultInFilm.sort {$0.name < $1.name}
            config.text = allCharactersResultInFilm.count > 0 ? allCharactersResultInFilm[indexPath.row].name : "Unable to show characters, try again later"
        case .characters:
            allFilmsResultForCharacter.sort {$0.releaseDate > $1.releaseDate}
            config.text = allFilmsResultForCharacter.count > 0 ? allFilmsResultForCharacter[indexPath.row].title : "Unable to show films, try again later"
            config.secondaryText = allFilmsResultForCharacter.count > 0 ? allFilmsResultForCharacter[indexPath.row].releaseDate : "No date"
        }
        cell.contentConfiguration = config
        return cell
    }
}
