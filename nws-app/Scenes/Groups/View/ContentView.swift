//
//  ContentView.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 20.02.22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    init() {
        //FirebaseApp.configure()
    }
    
    var body: some View {
        
        NavigationView{
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
