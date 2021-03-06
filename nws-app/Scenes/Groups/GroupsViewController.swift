//
//  GroupsViewController.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import UIKit
import SwiftUI

class GroupsViewController: UIViewController {
    
    @IBOutlet private weak var theContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: ContentView())
        childView.tabBarController?.tabBar.barTintColor = UIColor.systemBackground
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        setStrings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UITabBar.appearance().barTintColor = UIColor.systemBackground
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GroupsViewController {
    
    private func setStrings() {
        navigationItem.title = "Группы"
    }
}
