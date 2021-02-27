//
//  FavouritesCell.swift
//  Podcast
//
//  Created by Kingsley Charles on 27/02/2021.
//

import UIKit

class FavouritesCell: UICollectionViewCell {
    
    var podcast: Podcast? {
        didSet{
            guard let podcast = podcast else {return}
            podcastName.text = podcast.collectionName
            artistName.text = podcast.artistName
            podcastImage.sd_setImage(with: URL(string: podcast.artworkUrl600 ?? ""))
        }
    }
    lazy var podcastName: UILabel = {
        let lbl = UILabel()
        lbl.text = "Podcast Name"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var artistName: UILabel = {
        let lbl = UILabel()
        lbl.text = "Artist"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .gray
        return lbl
    }()
    
    lazy var podcastImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpStackView() {
        let stackview = UIStackView(arrangedSubviews: [podcastImage, podcastName, artistName])
        stackview.axis = .vertical
        addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}
