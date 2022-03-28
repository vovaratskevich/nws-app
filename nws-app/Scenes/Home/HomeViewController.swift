//
//  HomeViewController.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {

    @IBOutlet weak var smiImageView: UIImageView!
    @IBOutlet weak var sborImageView: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        smiImageView.layer.cornerRadius = 10
        sborImageView.layer.cornerRadius = 10
        topImage.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.backgroundColor = .white
    }
    
    @IBAction func topButtonTapped(_ sender: Any) {
        let url = URL(string: "http://ggpk.by/News/2022-03-25-2217.html")
        if let url = url {
            let vc = SFSafariViewController(url: url )
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func smiButtonTapped(_ sender: Any) {
        let url = URL(string: "http://ggpk.by/News/2022-03-03-1403.html")
        if let url = url {
            let vc = SFSafariViewController(url: url )
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func sborButtonTupped(_ sender: Any) {
        let url = URL(string: "http://ggpk.by/News/2021-10-14-0938.html")
        if let url = url {
            let vc = SFSafariViewController(url: url )
            self.present(vc, animated: true, completion: nil)
        }
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
