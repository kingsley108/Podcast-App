//
//  playerDetailsView.swift
//  Podcast
//
//  Created by Kingsley Charles on 18/02/2021.
//

import UIKit
import SDWebImage
import AVFoundation

class playerDetailsView: UIView {
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var podcastAuthor: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var episodeImage: UIImageView! {
        didSet{
            episodeImage.layer.cornerRadius = 8
            episodeImage.clipsToBounds = true
            episodeImage.transform = self.shrunkenTransform
        }
    }
    
    func enlargeImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = .identity
        }
        
    }
    
    func shrinkImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = self.shrunkenTransform
        }
    }
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    @IBAction func dismissPlayer(_ sender: Any) {
        removeFromSuperview()
    }
    
    
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    var episode: Episodes? {
        didSet{
            guard let episode = episode else {return}
            episodeTitle.text = episode.title
            let imageUrlString = episode.imageUrl == "" ? episode.podcastArtUrl!: episode.imageUrl
            podcastAuthor.text = episode.author
            configurePlayer()
            episodeImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    @IBAction func playPauseControls(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            player.pause()
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkImage()
        }
        else {
            player.play()
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeImage()
        }
    }
    
    fileprivate func configurePlayer() {
        guard let episode = episode else {return}
        guard let url = URL(string: episode.audioStream) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
         player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeImage()
        }
    }
    
}
