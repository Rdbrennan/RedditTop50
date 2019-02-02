//
//  PostTableViewCell.swift
//  RedditTop50
//
//  Created by Robert Brennan on 2/2/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation
import UIKit

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
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postComments: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
