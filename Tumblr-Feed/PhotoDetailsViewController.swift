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
        setCaption()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fullScreenPhotoViewController = segue.destination as! FullScreenPhotoViewController
        fullScreenPhotoViewController.photo = photo
    }
    
    func setCaption(){
        let caption = self.photo!["caption"] as! String
        let captionTextView = UITextView()
        view.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true
        captionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captionTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        captionTextView.isEditable = false
        captionTextView.font = UIFont.boldSystemFont(ofSize: 14)
        let s = caption.replacingOccurrences(of: "<p>", with: "")
        let a = s.replacingOccurrences(of: "\n", with: "")
        let b = a.replacingOccurrences(of: "<br/>", with: "")
        let c = b.replacingOccurrences(of: "</p>", with: "")
        let newCaption = c.replacingOccurrences(of: "(", with: "\n\t(")
        captionTextView.text = newCaption
    }


}
