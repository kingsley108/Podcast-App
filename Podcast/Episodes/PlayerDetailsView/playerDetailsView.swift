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
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var podcastAuthor: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
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
            episodeImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
            configurePlayer()
        }
    }
    @IBAction func playButton(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            player.pause()
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        else {
            player.play()
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    fileprivate func configurePlayer() {
        guard let episode = episode else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            guard let audioStream = URL(string: episode.audioStream) else {return}
            player = AVPlayer(url: audioStream)
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
        }
        catch {
            print("there was an error playing the audio", error)
        }
    }
    
   
}
