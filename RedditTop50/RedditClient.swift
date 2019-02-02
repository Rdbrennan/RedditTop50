//
//  RedditClient.swift
//  RedditTop50
//
//  Created by Robert Brennan on 1/31/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation

class RedditClient: NSObject{
    func fetchPosts(completion: @escaping ([NSDictionary]?) -> Void){
        
        let jsonUrlString = "https://reddit.com/top"
        guard let url = URL(string: jsonUrlString) else
        { return }
        let redditSession = URLSession.shared
    }
}
