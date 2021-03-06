//
//  NewsTableViewCell.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 24.01.22.
//

import UIKit
import SwiftSoup

class NewsTableViewCellViewModel {
    
    var title: String
    var pubDate: String
    var description: String
    var link: String
    var imageURL: String? = nil
    
    init(
        title: String,
        pubDate: String,
        description: String,
        link: String,
        imageURL: String
    ) {
        self.title = title
        self.pubDate = pubDate
        self.description = description
        self.link = link
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 2
        lable.textColor = .white
        lable.font = .systemFont(ofSize: 25, weight: .bold)
        return lable
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 3
        lable.font = .systemFont(ofSize: 18 , weight: .medium)
        lable.textColor = .gray
        return lable
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDescriptionLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.layer.cornerRadius = 10
        
//        newsImageView.translatesAutoresizingMaskIntoConstraints = false
//        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        newsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        newsImageView.frame = CGRect(
            //x: contentView.frame.size.width - 150,
            x: 10,
            y: 10,
            width: contentView.frame.size.width - 20,
            height: 160
        )
        
        newsTitleLabel.frame = CGRect(
            x: 20,
            y: 90,
            width: contentView.frame.size.width - 40,
            height: 70
        )

        newsDescriptionLabel.frame = CGRect(
            x: 20,
            y: 150,
            width: contentView.frame.size.width - 40,
            height: contentView.frame.size.height/2
        )

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDescriptionLabel.text = viewModel.description
        
        if let imageURL = viewModel.imageURL {
            let url = URL(string: imageURL)
            URLSession.shared.dataTask(with: url ?? URL(string: "nil")!) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
//    func getImageURLFromDescription(with html: String) -> String {
//        guard let doc: Document = try? SwiftSoup.parse(html) else { return " "} // parse html
//        let elements = try doc.select("[name=transaction_id]") // query
//        let transaction_id = try elements.get(0) // select first element
//        let value = try transaction_id.val() // get value
//        return value
//    }
}
