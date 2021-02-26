//
//  playerGesture.swift
//  Podcast
//
//  Created by Kingsley Charles on 25/02/2021.
//

import Foundation
import UIKit

extension PlayerDetailsView {
    
    func setUpGestures() {
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture)))
        setUpTapGesture()
        setUpMainPlayerGestures()
    }
    
    @objc func handleGesture(sender: UIPanGestureRecognizer) {
        performDragGesture(gesture: sender)
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        miniPlayerView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        animateTranslateUp()
    }
    
    func performDragGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            viewTranslation = gesture.translation(in: self)
            velocity = gesture.velocity(in: self)
            mainPlayerView.alpha = CGFloat(1 - viewTranslation.y/600)
            miniPlayerView.alpha = -(30/viewTranslation.y)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
            
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                if self.viewTranslation.y > -220 && self.velocity.y > -3000  {
                    self.animateTranslateDown()
                }
                else {
                    self.animateTranslateUp()
                }
            })
            
        default:
            break
        }
    }
    
    func animateTranslateDown() {
       
            self.miniPlayerView.alpha = 1
            self.mainPlayerView.alpha = 0
        
    }
    
    func animateTranslateUp() {
        UIApplication.shared.getRootVC().maximizeView(episode: nil)
    }
        
}


