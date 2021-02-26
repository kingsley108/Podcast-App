//
//  mainPlayerDetailsGesture.swift
//  Podcast
//
//  Created by Kingsley Charles on 25/02/2021.
//

import Foundation
import UIKit

extension playerDetailsView {
    
    func setUpMainPlayerGestures () {
        mainPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDragDown)))
    }
    
    @objc func handleDragDown(sender: UIPanGestureRecognizer) {
        performMainPlayerDragGesture(gesture: sender)
    }
    
    func performMainPlayerDragGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            viewTranslation = gesture.translation(in: self)
            velocity = gesture.velocity(in: self)
            mainPlayerView.alpha = CGFloat(1 - viewTranslation.y/600)
            miniPlayerView.alpha = (viewTranslation.y/1000)
            print("#### translation: \(viewTranslation.y)")
            print("#### mainAlpha Values: \(mainPlayerView.alpha) miniAlpha : \(miniPlayerView.alpha)")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
            
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                if self.viewTranslation.y < 260 && self.velocity.y < 2000  {
                   self.animateTranslateUp()
                }
                else {
                    self.animateTranslateDown()
                    UIApplication.shared.getRootVC().minimizeView()
                }
            })
            
        default:
            break
        }
    }
}
