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
    
    //MARK: Web Outlets
    var post: Post?
    @IBOutlet var mediaWebView: WKWebView!
    let defaultUrl = URL(string: "https://i.redd.it/4jeme1xu9lq01.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaWebView.allowsBackForwardNavigationGestures = true

        //Fetch media from URL
        if let post = post, var url = URL(string: post.mediaURL) {
            if post.mediaURL != ""{
                //Videos
                if post.mediaURL.hasPrefix("https://v"){
                    print(url)
                    url = URL(string: post.mediafallbackURL)!
                    print(url)
                     mediaWebView.load(URLRequest(url: url))
                }
                //Image, Gif, Web
                else{
                    
                    mediaWebView.load(URLRequest(url: url))
                    print(url)
                }
                self.title = post.title
            }
        }
        else{
            //No Media Default
            mediaWebView.load(URLRequest(url: defaultUrl!))
        }

    }
    
    //MARK: Start Loading
    override func viewWillAppear(_ animated: Bool) {
        self.pleaseWait()

    }
    //MARK: End Loading
    override func viewDidAppear(_ animated: Bool) {
        self.clearAllNotice()

    }
}

