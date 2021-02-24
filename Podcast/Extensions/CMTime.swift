//
//  CMTime.swift
//  Podcast
//
//  Created by Kingsley Charles on 24/02/2021.
//

import Foundation
import CoreMedia

extension CMTime {
    var timeString: String {
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return "--:--"
        }
        let sInt = Int(seconds)
        let s: Int = sInt % 60
        let m: Int = (sInt / 60) % 60
        let h: Int = sInt / 3600
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
