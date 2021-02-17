//
//  EpisodesCell.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import UIKit
import SDWebImage

class EpisodesCell: UITableViewCell {
    var artworkUrl: String?
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
    
    var episodes: Episodes? {
        didSet{
            guard let episode = episodes else {return}
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, y"
            episodeCount.text = formatter.string(from: episode.pubdate)
            episodeDescription.text = episode.description
            episodeTitle.text = episode.title
        
            episodeImage.sd_setImage(with: URL(string: artworkUrl!), completed: nil)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
