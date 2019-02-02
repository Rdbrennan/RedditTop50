//
//  ViewController.swift
//  RedditTop50
//
//  Created by Robert Brennan on 1/31/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import UIKit

struct Post {
    let name: String
//    let time: String
    let title: String
    let mediaURL: String
    let comments: Int
}

class PostsViewController: UIViewController {
    
    //MARK: Variables
    
    var postsArray = [Post]()

    @IBOutlet var postsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRedditPosts()
    }
    
    func fetchRedditPosts(){
        guard let redditUrl = URL(string: "https://www.reddit.com/top/.json?limit=3") else { return }
        
        let request = URLRequest(url: redditUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                
            } else if data != nil {
                do {
                    let results = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    if let elementDict = results["data"] as? [String: Any] {
                        if let elements = elementDict["children"] as? [Any] {
                            for one in elements {
                                if let element = one as? [String:Any] {
                                    if let postDict = element["data"] as? [String:Any] {
                                        
                                        guard let name = postDict["author_fullname"] as? String,
//                                              let time = postDict["time"] as? String,
                                              let title = postDict["title"] as? String,
                                              let mediaURL = postDict["url"] as? String,
                                              let comments = postDict["num_comments"] as? Int else {
                                                print("uh oh")
                                                break
                                                
                                        }
                                        self.postsArray.append(Post(name: name, /*time: time,*/ title: title, mediaURL: mediaURL, comments: comments))
                                    }
                                }
                            }
                            print(self.postsArray.count)
                            DispatchQueue.main.async(execute: {
                                self.postsTableView.reloadData()
                            })
                        }
                    }
                    
                } catch {
                    print("JSON error")
                }
            } else {
                print("no error and no data")
            }
        })
        task.resume()

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? WebVC, let postIndex = postsTableView.indexPathForSelectedRow?.row {
//            destination.post = postsArray[postIndex]
//        }
//    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postsArray.count > 0 {
            return postsArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath) as? PostTableViewCell, postsArray.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath)
            return cell
        }
        
        let post = postsArray[indexPath.row]
        
        cell.name.text = post.name
        cell.postTitle.text = post.title
        cell.postImage.image = UIImage(named: "RedditIcon")
        cell.postComments.text = post.comments.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
