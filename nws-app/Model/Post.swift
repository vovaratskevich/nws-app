//
//  Post.swift
//  Post
//
//  Created by Balaji on 10/08/21.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

// Post Model...
struct Post: Identifiable,Codable{
    @DocumentID var id: String?
    var title: String
    var date: Timestamp
    var author: String
    var group: String
    var postContent: [PostContent]
    
    enum CodingKeys: String,CodingKey{
        case id
        case title
        case date
        case author
        case group
        case postContent
    }
}

// Post COntent Model...
struct PostContent: Identifiable,Codable{
    var id = UUID().uuidString
    var value: String
    var type: PostType
    // For Height...
    // Only for UI not for backend...
    var height: CGFloat = 0
    var showImage: Bool = false
    var showDeleteAlert: Bool = false
    
    enum CodingKeys: String,CodingKey{
        // Since firestore keyname is key...
        case type = "key"
        case value
    }
}

// COntent Type..
// Eg Header , Paragraph...
enum PostType: String,CaseIterable,Codable{
    
    case Header = "Заголовок"
    case SubHeading = "Подзаголовок"
    case Paragraph = "Абзац"
    case Image = "Изображение"
}
