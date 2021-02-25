
import UIKit
import SDWebImage
import AVFoundation

class playerDetailsView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var mainPlayerView: UIStackView!
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
    
    //Mini Player Outlets
    @IBOutlet weak var miniPlayerEpisodeLabel: UILabel!
    @IBAction func miniPlayerFastFowardAction(_ sender: UIButton) {
        self.scrub15Sec(sender)
    }
    @IBOutlet weak var miniPlayerImage: UIImageView!{
        didSet{
            episodeImage.layer.cornerRadius = 8
            episodeImage.clipsToBounds = true
            episodeImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayerPlayControls: UIButton!
    @IBAction func miniPlayerPlayAction(_ sender: UIButton) {
        self.playPauseControls(sender)
        
    }
    
    //MARK: - Main App functions
    var episode: Episodes? {
        didSet{
            guard let episode = episode else {return}
            episodeTitle.text = episode.title
            let imageUrlString = episode.imageUrl == "" ? episode.podcastArtUrl!: episode.imageUrl
            podcastAuthor.text = episode.author
            miniPlayerEpisodeLabel.text = episode.title
            configurePlayer()
            episodeImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
            miniPlayerImage.sd_setImage(with: URL(string: imageUrlString), completed: nil)
        }
    }
    
    func enlargeImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = .identity
        }
        
    }
    
    static func loadNib() -> playerDetailsView {
        return Bundle.main.loadNibNamed("playerDetailsView", owner: self, options: nil)!.first as! playerDetailsView
    }
    
    func shrinkImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    @IBAction func dismissPlayer(_ sender: Any) {
        UIApplication.shared.getRootVC().minimizeView()
    }
    
    @IBAction func volumeSliderMoved(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    
    @IBAction func playPauseControls(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            player.pause()
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkImage()
        }
        else {
            player.play()
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
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
            miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
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
        
        setUpGestures()
        
        let observerTime = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: observerTime, queue: .main) { [weak self] (progresstime) in
            self?.startTimeLabel.text = progresstime.timeString
            self?.updateSlider()
        }
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            guard let durationTime = self?.player.currentItem?.duration.timeString else {return}
            self?.finishTimeLabel.text = durationTime
            self?.enlargeImage()
        }
    }
    
    fileprivate func setUpGestures() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        
        let viewTranslation: CGPoint
        switch sender.state {
        case .changed:
             viewTranslation = sender.translation(in: self)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
            })
            
        case .ended:
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                       self.transform = .identity
                    self.miniPlayerView.alpha = 1
                    self.mainPlayerView.alpha = 0
                   })
        default:
            break
        }
    }
    
    @IBAction func playerSliderScrubber(_ sender: UISlider, event: UIEvent) {
        let sliderValue = Float64(playerSlider.value)
        let durationTime = CMTimeGetSeconds(player.currentItem!.duration)
        let seekTimeInSeconds = CMTimeMakeWithSeconds(sliderValue * durationTime, preferredTimescale: 1)
        print(seekTimeInSeconds)
        player.seek(to: seekTimeInSeconds)
    }
    
    @IBAction func scrub15Sec(_ sender: UIButton) {
        self.playerscrubber(forSec: 15)
        
    }
    
    @IBAction func scrubBackwards15Sec(_ sender: UIButton) {
        self.playerscrubber(forSec: -15)
    }
    
    fileprivate func playerscrubber(forSec: Int) {
        let scrubTime = CMTimeMake(value: Int64(forSec), timescale: 1)
        let currentTime = player.currentTime()
        let seekTime = CMTimeAdd(scrubTime, currentTime)
        player.seek(to: seekTime)
    }
    
    fileprivate func updateSlider() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let finishTime = CMTimeGetSeconds(player.currentItem!.duration)
        let sliderPercentage = (currentTime/finishTime)
        playerSlider.value = Float(sliderPercentage)
    }
}
