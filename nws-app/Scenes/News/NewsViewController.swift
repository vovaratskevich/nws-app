//
//  ViewController.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 19.01.22.
//

import UIKit
import SwiftSoup
import SafariServices

class NewsViewController: UIViewController {
    
    let searchController = UISearchController()
    
    private var rssItems = [RSSItem]()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var filteredViewModels = [NewsTableViewCellViewModel]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по названию"
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        //tabBarController?.tabBar.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupView() {
        navigationItem.title = "Новости"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
    }
    
    private func fetchData() {
        let feedService = FeedService()
        feedService.parseFeed(url: "http://ggpk.by//news.rss") { rssItems in
            self.rssItems = rssItems
            self.viewModels = rssItems.compactMap({
                NewsTableViewCellViewModel(title: $0.title,
                                           pubDate: $0.pubDate,
                                           description: $0.description.withoutHTMLTags.trimmingCharacters(in: .whitespacesAndNewlines),
                                           link: $0.link,
                                           imageURL: self.getImageURLFromDescription(with: $0.description))
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getImageURLFromDescription(with html: String) -> String {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            if let link: Element = try doc.select("img").first() {
                let linkHref: String = try link.attr("src"); // "/Files/image/sovet_deputatov9.jpg"
                let domen = "http://ggpk.by"
                return domen + linkHref
            }
            return "img not found"
        }  catch {
            return "error"
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredViewModels.count
        }
        return viewModels.count
    } 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        
        var viewModel: NewsTableViewCellViewModel
        
        if isFiltering {
            viewModel = filteredViewModels[indexPath.row]
        } else {
            viewModel = viewModels[indexPath.row]
        }
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var viewModel: NewsTableViewCellViewModel
        
        if isFiltering {
            viewModel = filteredViewModels[indexPath.row]
        } else {
            viewModel = viewModels[indexPath.row]
        }
        
        guard let url = URL(string: viewModel.link) else {
            return
        }
        
        let vc = SFSafariViewController(url: url )
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
}

extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filteredContentForSearchText(_ searchText: String) {
        filteredViewModels = viewModels.filter({ (viewModels: NewsTableViewCellViewModel) -> Bool in
            return viewModels.title.lowercased().contains(searchText.lowercased() )
        })
        
        tableView.reloadData()
    }
}


