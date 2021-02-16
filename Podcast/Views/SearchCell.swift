

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastName: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var podcastCreative: UIImageView!
    
    var podcast: Podcast? {
        didSet{
            guard let podName = podcast?.collectionName else {return}
            guard let podAuthor = podcast?.artistName else {return}
            podcastName!.text = podName
            authorLabel!.text = podAuthor
            podcastCreative!.image = #imageLiteral(resourceName: "appicon")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
