//
//  playerDetailsView.swift
//  Podcast
//
//  Created by Kingsley Charles on 18/02/2021.
//

import UIKit
import SDWebImage

class playerDetailsView: UIView {
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBAction func dismissPlayer(_ sender: Any) {
        removeFromSuperview()
    }
    
    
    
    var episode: Episodes? {
        didSet{
            guard let episode = episode else {return}
            episodeTitle.text = episode.title
            let imageUrlString = (episode.imageUrl == "" ? episode.podcastArtUrl: episode.imageUrl) ?? ""
            episodeImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    
   
}
