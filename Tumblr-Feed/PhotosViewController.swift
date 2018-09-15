//
//  PhotosViewController.swift
//  Tumblr-Feed
//
//  Created by Jesus Andres Bernal Lopez on 9/7/18.
//  Copyright © 2018 Jesus Andres Bernal Lopez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts : [[String: Any]] = []
    var refreshFeed = UIRefreshControl()
    var currentIndex = 0
    
    let alertControl = UIAlertController(title: "Error: Network Connection Required", message: "Check internet connection and try agin.", preferredStyle: .alert)
    
    @IBOutlet weak var photoFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        photoFeedTableView.delegate = self
        photoFeedTableView.dataSource = self
        
        let tryAgainButton = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchFeed()
        }
        alertControl.addAction(tryAgainButton)
        
        refreshFeed.addTarget(self, action: #selector(didPulltoRefresh), for: .valueChanged)
        photoFeedTableView.insertSubview(refreshFeed, at: 0)
        
        fetchFeed()
    }
    
    @objc func didPulltoRefresh(){
        fetchFeed()
    }
    
    func fetchFeed(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.present(self.alertControl, animated: true)
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.photoFeedTableView.reloadData()
                self.photoFeedTableView.reloadData()
                self.refreshFeed.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let dateLabel = UILabel()
        headerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            dateLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: profileView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let post = posts[currentIndex]
        let date = post["date"] as! String
            
        dateLabel.text = date
        
        return headerView

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.section]
        currentIndex = indexPath.section
        if let photos = post["photos"] as? [[String: Any]]{
            let photo = photos[0]
            let origionalSize = photo["original_size"] as! [String: Any]
            let urlString = origionalSize["url"] as! String
            let url = URL(string: urlString)

            cell.photoCellImageView.af_setImage(
                withURL: url!,
                placeholderImage: UIImage(named: "tumblr-feed placeholder"),
                imageTransition: UIImageView.ImageTransition.flipFromBottom(0.5),
                runImageTransitionIfCached: false)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = photoFeedTableView.indexPath(for: cell){
            let photo = posts[indexPath.section]
            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            photoDetailsViewController.photo = photo
        }
    }
}
