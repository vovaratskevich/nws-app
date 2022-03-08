//
//  BlogViewModel.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 20.02.22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class BlogViewModel: ObservableObject {
 
    @Published var posts: [Post]?
    
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    // New Post...
    @Published var createPost = false
    @Published var isWriting = false
    @Published var isActive = false
    
    func getData() {
        //get a reference to the database
        let db = Firestore.firestore()
        
        //read the doucuments at a specific path
        db.collection("Blog").getDocuments { [self] snapshot, error in
            //check for errors
            if error == nil {
                //no errors
                //check for items
                if let snapshot = snapshot {
                    //update the list property in the mainthread
                   
                    DispatchQueue.main.async {
                        //get all the documents  and create Posts
                        //do {
                            self.posts = snapshot.documents.compactMap({ post in
                                return try? post.data(as: Post.self)
                            })
//                        //} catch {
//                            alertMsg = error.localizedDescription
//                            self.showAlert.toggle()
//                        }
//                        self.posts = snapshot.documents.map { post in
//                            return Post(id: post.documentID, title: post["title"] as? String ?? "", author: post["title"] as? String ?? "", postContent: post["title"] as? [PostContent], date: post["title"] as? Timestamp)
//                        }
                    }
                }
            }
        }
    }
    
    func fetchPosts() async {
        do {
            let db = Firestore.firestore().collection("Blog")
            let posts = try await db.getDocuments()
            
            self.posts = posts.documents.compactMap({ post in
                return try? post.data(as: Post.self)
            })
        } catch {
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deletePost(post: Post) {
        guard let _ = posts else { return }
        
        let index = posts?.firstIndex(where: { currentPost in
            return currentPost.id == post.id
        }) ?? 0
        
        withAnimation {
            posts?.remove(at: index)
        }
    }
    
    func writePost(content: [PostContent],author: String,postTitle: String, group: String){
        
        do{
            
            // Loading Animation...
            withAnimation{
                isWriting = true
            }
            
            // Storing to DB...
            let post = Post(title: postTitle, date: Timestamp(date: Date()), author: author, group: group, postContent: content)
            
            let _ = try Firestore.firestore().collection("Blog").document().setData(from: post, completion: { err in
                if let _ = err{
                    return
                }
                
                withAnimation{[self] in
                    // adding to posts...
                    posts?.append(post)
                    isWriting = false
                    // Closing Post View...
                    createPost = false
                }
            })
            
            
        }
        catch{
            print(error.localizedDescription)
        }
    }

}
