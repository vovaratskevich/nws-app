//
//  Home.swift
//  Home
//
//  Created by Balaji on 10/08/21.
//

import SwiftUI

struct Home: View {
    @ObservedObject var blogData = BlogViewModel()
    @State private var isActive = false
    
    // Color Based on ColorScheme...
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack{
            
            if let posts = blogData.posts{
                
                // No Posts...
                if posts.isEmpty{
                    
                    (
                        Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                         +
                        
                        Text("Новостей нет")
                    )
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                else{
                    
                    List(posts){post in
                        
                        // CardView...
                        CardView(post: post)
                        // Swipe to delete...
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                
                                Button(role: .destructive) {
                                    blogData.deletePost(post: post)
                                } label: {
                                    
                                    Image(systemName: "trash")
                                }

                            }
                    }
                    .listStyle(.insetGrouped)
                    
                }
            }
            else{

                ProgressView()
            }
            
        }
        .navigationTitle("Новости групп")
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
        
            // FAB Button...
            Button(action: {
                blogData.createPost.toggle()
            }, label: {
                
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(scheme == .dark ? .black : .white)
                    .padding()
                    .background(.primary,in: Circle())
            })
            .padding()
            .foregroundStyle(.primary)
            .disabled(isActive == false)
            ,alignment: .bottomTrailing
        )
        
        // fetching Blog Posts...
        .task {
            let userDefault = UserDefaults.standard

            let savedData = userDefault.bool(forKey: "isLoggedIn")
            if(savedData){
                isActive = true
            }else{
                isActive = false
            }

            await blogData.fetchPosts()
        }
        .fullScreenCover(isPresented: $blogData.createPost, content: {
            
            // Create Post View....
            CreatePost()
                .overlay(
                
                    ZStack{
                        
//                        .primary.opacity(0.25)
//                            .ignoresSafeArea()
                        
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .background(scheme == .dark ? .black : .white,in: RoundedRectangle(cornerRadius: 15))
                    }
                    .opacity(blogData.isWriting ? 1 : 0)
                )
                .environmentObject(blogData)
        })
        .alert(blogData.alertMsg, isPresented: $blogData.showAlert) {
            
        }
    }
    
    @ViewBuilder
    func CardView(post: Post)->some View{
        
        // Detail View...
        NavigationLink {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text("Автор: \(post.author)")
                        .foregroundColor(.gray)
                    
                    Text("Группа: \(post.group)")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Text("Дата публикации: \(            post.date.dateValue().formatted(date: .numeric, time: .shortened))")
                        .foregroundColor(.gray)
                    
                    ForEach(post.postContent){content in
                        
                        if content.type == .Image{
                            WebImage(url: content.value)
                        }
                        else{
                            Text(content.value)
                                .font(.system(size: getFontSize(type: content.type)))
                                .lineSpacing(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(post.title)
            
        } label: {
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(post.title)
                    .fontWeight(.bold)
                
                Text("Автор: \(post.author)")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                Text("Группа: \(post.group)")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                Text("Дата публикации: \(            post.date.dateValue().formatted(date: .numeric, time: .omitted))")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
            }
        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
