//
//  PhotoDetailsViewController.swift
//  Tumblr-Feed
//
//  Created by Jesus Andres Bernal Lopez on 9/14/18.
//  Copyright © 2018 Jesus Andres Bernal Lopez. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo : [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photos = photo!["photos"] as? [[String: Any]] {
            let photo = photos[0] 
            let origionalSize = photo["original_size"] as! [String: Any]
            let urlString = origionalSize["url"] as! String
            let url = URL(string: urlString)!
            photoImageView.af_setImage(withURL: url)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fullScreenPhotoViewController = segue.destination as! FullScreenPhotoViewController
        fullScreenPhotoViewController.photo = photo
    }


}
