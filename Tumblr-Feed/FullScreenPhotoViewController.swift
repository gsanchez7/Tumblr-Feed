//
//  FullScreenPhotoViewController.swift
//  Tumblr-Feed
//
//  Created by Jesus Andres Bernal Lopez on 9/14/18.
//  Copyright © 2018 Jesus Andres Bernal Lopez. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var fullScreenScrollView: UIScrollView!
    
    var photo : [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenScrollView.delegate = self
        
        if let photos = photo!["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let origionalSize = photo["original_size"] as! [String: Any]
            let urlString = origionalSize["url"] as! String
            let url = URL(string: urlString)!
            fullScreenImageView.af_setImage(withURL: url)
        }
        fullScreenImageView.isUserInteractionEnabled = true
    }
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImageView
    }
    
}
