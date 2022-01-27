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
    
    private var rssItems = [RSSItem]()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
        return viewModels.count
    } 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rssItem = rssItems[indexPath.row]
        
        guard let url = URL(string: rssItem.link) else {
            return
        }
        
        let vc = SFSafariViewController(url: url )
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 
    }
}


