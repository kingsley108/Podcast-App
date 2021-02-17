

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastName: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var podcastCreative: UIImageView!
    
    var podcast: Podcast? {
        didSet{
            guard let podName = podcast?.collectionName else {return}
            guard let podAuthor = podcast?.artistName else {return}
            guard let episodesNumber = podcast?.trackCount else {return}
            guard let podcastImage = URL(string: podcast?.artworkUrl600 ?? "") else {return}
            podcastName!.text = podName
            authorLabel!.text = podAuthor
            episodeCount.text = "\(episodesNumber)"
            podcastCreative!.sd_setImage(with: podcastImage,completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
