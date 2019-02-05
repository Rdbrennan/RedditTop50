//
//  ViewController.swift
//  RedditTop50
//
//  Created by Robert Brennan on 1/31/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import UIKit
import RevealingSplashView

class PostsViewController: UIViewController {
    
    //MARK: Variables
    
    var postsArray = [Post]()
    var uniqueArray = [Post]()

    @IBOutlet var postsTableView: UITableView!
    
    var mediafallbackURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "AppIconOriginal")!,iconInitialSize: CGSize(width: 240, height: 209), backgroundColor: UIColor.white)
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        //Fetch Posts
        fetchRedditPosts()
    }
    
    //MARK: Iterate Reddit JSON data to obtain children (aka the data)
    func fetchRedditPosts(){
        guard let redditUrl = URL(string: "https://www.reddit.com/top/.json?limit=50") else { return }
//        self.pleaseWait()
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
                                                print("JSON data error")
                                                break
                                                
                                        }
                                        if let media = postDict["secure_media"] as? [String:Any] {
                                            if let media1 = media["reddit_video"] as? [String:Any] {
                                                    
                                                    guard let mediafallbackURL = media1["fallback_url"] as? String else {
                                                            print("JSON data error")
                                                            break
                                                            
                                                    }
                                                
                                                    self.postsArray.append(Post(name: name, time: time, title: title, mediaURL: mediaURL, comments: comments, mediafallbackURL: mediafallbackURL))
                                            }
                                        }
                                        self.postsArray.append(Post(name: name, time: time, title: title, mediaURL: mediaURL, comments: comments, mediafallbackURL: ""))
                                        self.clearAllNotice()
                                    }
                                }
                            }
                            
                            var seen = Set<String>()
                            for message in self.postsArray {
                                if !seen.contains(message.title) {
                                    self.uniqueArray.append(message)
                                    seen.insert(message.title)
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                self.postsTableView.reloadData()
                            })
                        }
                    }
                    
                } catch {
                    print("JSON error")
                }
            } else {
                print("No errors & no data")
            }
        })
        task.resume()
    }
    
    //MARK: Populate Posts Array in Media View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MediaViewController, let postIndex = postsTableView.indexPathForSelectedRow?.row {
            destination.post = uniqueArray[postIndex]
        }
    }
}

//MARK: TableViewController Extentsion
extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uniqueArray.count > 0 {
            return uniqueArray.count
        } else {
            return 1
        }
    }
    
    //MARK: Load Data utilizing Model and ViewModel
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath) as? PostTableViewCell, uniqueArray.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath)
            return cell
        }
        
        let post = uniqueArray[indexPath.row]

        let url = URL(string: post.mediaURL)

        ImageService.getImage(withURL: url!) { image, URL in            
            if post.mediaURL.hasSuffix(".jpg"){
                cell.referenceImage.image = image
            }
            else {
                cell.referenceImage.image = UIImage(named: "PlaceholderImage")
            }
        }
        let startDate = Date(timeIntervalSince1970: post.time)
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


extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
