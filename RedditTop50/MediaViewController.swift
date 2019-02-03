//
//  MediaViewController.swift
//  RedditTop50
//
//  Created by Robert Brennan on 2/2/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class MediaViewController: UIViewController {
    
    //MARK: Outlets
    
    var post: Post?
    @IBOutlet var mediaWebView: WKWebView!
    let defaultUrl = URL(string: "https://i.redd.it/4jeme1xu9lq01.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post, let url = URL(string: post.mediaURL) {
            mediaWebView.load(URLRequest(url: url))
            print(url)
            self.title = post.title
        }
        else{
            mediaWebView.load(URLRequest(url: defaultUrl!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
