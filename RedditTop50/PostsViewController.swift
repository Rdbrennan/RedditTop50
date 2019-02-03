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
    let time: Double
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
        guard let redditUrl = URL(string: "https://www.reddit.com/top/.json?limit=50") else { return }
        
        let request = URLRequest(url: redditUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                
            } else if data != nil {
                do {
                    let results = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    if let postsDictionary = results["data"] as? [String: Any] {
                        if let elements = postsDictionary["children"] as? [Any] {
                            for onePost in elements {
                                if let element = onePost as? [String:Any] {
                                    if let postDict = element["data"] as? [String:Any] {
                                        
                                        guard let name = postDict["author"] as? String,
                                              let time = postDict["created_utc"] as? Double,
                                              let title = postDict["title"] as? String,
                                              let mediaURL = postDict["url"] as? String,
                                              let comments = postDict["num_comments"] as? Int else {
                                                print("uh oh")
                                                break
                                                
                                        }
                                        self.postsArray.append(Post(name: name, time: time, title: title, mediaURL: mediaURL, comments: comments))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MediaViewController, let postIndex = postsTableView.indexPathForSelectedRow?.row {
            destination.post = postsArray[postIndex]
        }
    }
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

        let url = URL(string: post.mediaURL)

        ImageService.getImage(withURL: url!) { image, URL in            
            if post.mediaURL.hasSuffix(".jpg"){
                cell.referenceImage.image = image
            }
            else {
                cell.referenceImage.image = UIImage(named: "placeholderimage")
            }
        }
        let startDate = Date(timeIntervalSince1970: post.time)
//        cell.referenceImage = post.
        cell.postTime.text = startDate.postTimeCalculation()
        cell.name.text = (post.name + "   •   ")
        cell.postTitle.text = post.title
        cell.postComments.text = post.comments.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: Post Time Calculation
extension Date {
    func postTimeCalculation() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
