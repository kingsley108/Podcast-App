
import UIKit
import Foundation
import SDWebImage
import AVFoundation
import MediaPlayer

class PlayerDetailsView: UIView {
    var nowPlayingInfo: [String: Any]?
    var nowPlayingInfoImage: UIImage?
    var listOfEpisodes = [Episodes]()
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
    var viewTranslation = CGPoint(x: 0, y: 0)
    var velocity = CGPoint(x:0, y:0)
    
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
            miniPlayerImage.sd_setImage(with: URL(string: imageUrlString)) { (image, err, cache, url) in
                self.nowPlayingInfoImage = image
            }
        }
    }
    
    func enlargeImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImage.transform = .identity
        }
        
    }
    
    static func loadNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("playerDetailsView", owner: self, options: nil)!.first as! PlayerDetailsView
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
        setElapsedTime()
        if player.timeControlStatus == .playing {
            player.pause()
            nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
            nowPlayingInfo?[ MPNowPlayingInfoPropertyPlaybackRate] = 0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkImage()
        }
        else {
            player.play()
            nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
            nowPlayingInfo?[ MPNowPlayingInfoPropertyPlaybackRate] = 1
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeImage()
        }
    }
    
    fileprivate func playAudioStream(_ audioStream: URL) throws {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        let playerItem = AVPlayerItem(url: audioStream)
        player.replaceCurrentItem(with: playerItem)
        playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        player.play()
    }
    
    fileprivate func configurePlayer() {
        do {
            guard let episode = episode else {return}
            if episode.downloadedEpisodeFilePath != nil {
                let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
                let url = URL(string: episode.downloadedEpisodeFilePath ?? "")
                let lastPathComponent = url?.lastPathComponent
                let fileUrl = documentUrl.appendingPathComponent(lastPathComponent!)
                try playAudioStream(fileUrl)
                return
            }
            
            guard let audioStream = URL(string: episode.audioStream) else {return}
            try playAudioStream(audioStream)
        }
        catch {
            print("there was an error playing the audio", error)
        }
    }
    
    
    fileprivate func addObservers() {
        let time = CMTimeMake(value: 1,timescale: 3)
        let times = [NSValue(time: time)]
        let observerTime = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: observerTime, queue: .main) { [weak self] (progresstime) in
            self?.startTimeLabel.text = progresstime.timeString
            guard let durationTime = self?.player.currentItem?.duration.timeString else {return}
            self?.finishTimeLabel.text = durationTime
            self?.setUpNotificationView(img: (self?.nowPlayingInfoImage!)!)
            self?.updateSlider()
        }
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpGestures()
        addObservers()
        setupRemoteTransportControls()
        setupNotificationsInterruptions()
    }
    
    func setElapsedTime() {
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    
    @IBAction func playerSliderScrubber(_ sender: UISlider) {
        let sliderValue = Float64(playerSlider.value)
        let durationTime = CMTimeGetSeconds(player.currentItem!.duration)
        print(durationTime)
        let seekTimeInSeconds = CMTimeMakeWithSeconds(sliderValue * durationTime, preferredTimescale: 1)
        print(seekTimeInSeconds)
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo?[ MPNowPlayingInfoPropertyPlaybackRate] = 1
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
