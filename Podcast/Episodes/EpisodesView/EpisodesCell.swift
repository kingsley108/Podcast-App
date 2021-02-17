//
//  EpisodesCell.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import UIKit
import SDWebImage

class EpisodesCell: UITableViewCell {
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!{
        didSet{
            episodeDescription.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeTitle: UILabel!{
        didSet{
            episodeTitle.numberOfLines = 2
        }
    }
    var podcastArtUrl: String?
    var episodes: Episodes? {
        didSet{
            guard let episode = episodes else {return}
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, y"
            episodeCount.text = formatter.string(from: episode.pubdate)
            episodeDescription.text = episode.description
            episodeTitle.text = episode.title
            let imageUrlString = episode.imageUrl == "" ? podcastArtUrl!: episode.imageUrl
            episodeImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
