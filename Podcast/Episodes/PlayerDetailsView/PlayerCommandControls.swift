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
    }
}
