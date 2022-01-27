//
//  XMLParser.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 19.01.22.
//

import Foundation
import UIKit

//download xml from a server
//parse xml to foundation objects
//call back

class FeedService: NSObject, XMLParserDelegate {
    
    private var iteration = 0
    
    private var rssItems: [RSSItem] = []
    private var currentElemet = ""
    
    private var currentTitle: String = "" {
        didSet {
            //currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines )
        }
    }
    
    private var currentDescription: String = "" 
    
    private var currentPubDate: String = "" {
        didSet {
            //currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines )
        }
    }
    
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var parserComplitionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, complitionHandler: (([RSSItem]) -> Void)?) {
        self.parserComplitionHandler = complitionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            //parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
}

//MARK: - XMLParserDelegate

extension FeedService {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElemet = elementName
        if currentElemet == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentDescription = ""
            currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        var count = 0
        switch currentElemet {
        case "title":
            currentTitle += string
        case "pubDate":
            currentPubDate += string
        case "description":
            if count == 0 {
                let str = string.replacingOccurrences(of: "Подробнее", with: "", options: .literal, range: nil)
                currentDescription += str
                count += 1
            } else {
                break
            }
        case "link":
            currentLink += string.replaceOrgToBy
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, description: currentDescription, link: currentLink)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserComplitionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
