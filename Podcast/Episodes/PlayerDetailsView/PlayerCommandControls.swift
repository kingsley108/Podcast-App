//
//  commandControls.swift
//  Podcast
//
//  Created by Kingsley Charles on 26/02/2021.
//

import Foundation

import UIKit
import AVKit
import MediaPlayer

extension PlayerDetailsView {
    
    func setupRemoteTransportControls() {
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print(error)
        }
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                miniPlayerPlayControls.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
           changeTrack(moveFoward: true)
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            changeTrack(moveFoward: false)
            return .commandFailed
        }
        
    }
    
    fileprivate func changeTrack(moveFoward: Bool) {
        let offset = moveFoward ? 1: -1
        let episodesCount = listOfEpisodes.count
        guard let index = listOfEpisodes.firstIndex(where: { $0.title == episode!.title }) else {return}
        self.episode = listOfEpisodes[((index + offset) % episodesCount)]
    }
    
    
    func setUpNotificationView(img: UIImage) {
        nowPlayingInfo = [String: Any] ()
        guard let duration = player.currentItem?.duration else {return}
        nowPlayingInfo?[MPMediaItemPropertyTitle] = episode?.title
        nowPlayingInfo?[MPMediaItemPropertyArtist] = episode?.author
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo?[ MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: img.size, requestHandler: { (size) -> UIImage in
            return img
        })
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNotificationsInterruptions() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        switch type {
        case .began:
            // An interruption began. Update the UI as necessary.
            player.pause()
        case .ended:
           // An interruption ended. Resume playback, if appropriate.
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            self.playPauseControls(UIButton())
            if options.contains(.shouldResume) {player.play()}
        default: ()
        }
    }
}

