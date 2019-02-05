//
//  Post.swift
//  RedditTop50
//
//  Created by Robert Brennan on 2/3/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation

//MARK: Post Model Data
struct Post {
    let name: String
    let time: Double
    let title: String
    let mediaURL: String
    let comments: Int
    let mediafallbackURL: String
}
