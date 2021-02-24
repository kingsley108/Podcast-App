
import UIKit
import SDWebImage
import AVFoundation

class playerDetailsView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var podcastAuthor: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var episodeImage: UIImageView! {
        didSet{
            episodeImage.layer.cornerRadius = 8
            episodeImage.clipsToBounds = true
            episodeImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    func enlargeImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = .identity
        }
        
    }
    
    func shrinkImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            guard let audioStream = URL(string: episode.audioStream) else {return}
            let playerItem = AVPlayerItem(url: audioStream)
            player.replaceCurrentItem(with: playerItem)
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
        }
        catch {
            print("there was an error playing the audio", error)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = CMTimeMake(value: 1,timescale: 3)
        let times = [NSValue(time: time)]
        
        let observerTime = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: observerTime, queue: .main) { (progresstime) in
            self.startTimeLabel.text = progresstime.timeString
            self.updateSlider()
        }
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            guard let durationTime = self?.player.currentItem?.duration.timeString else {return}
            self?.finishTimeLabel.text = durationTime
            self?.enlargeImage()
        }
    }
    
    
    fileprivate func updateSlider() {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let finishTime = CMTimeGetSeconds(player.currentItem!.duration)
        let sliderPercentage = (currentTime/finishTime)
        playerSlider.value = Float(sliderPercentage)
    }
}
