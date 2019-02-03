//
//  PostTableViewCell.swift
//  RedditTop50
//
//  Created by Robert Brennan on 2/2/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PostTableViewCell: UITableViewCell {
    //MARK: Variables
    //title
    //author
    //image
    //comments
    //hoursAgo
    @IBOutlet var name: UILabel!
    @IBOutlet var postTime: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postComments: UILabel!
    @IBOutlet var postMedia: WKWebView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
