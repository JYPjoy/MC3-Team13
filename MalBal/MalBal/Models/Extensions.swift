//
//  Extensions.swift
//  MalBal
//
//  Created by kibum on 2023/07/26.
//

import Foundation

extension TimeInterval {
    func formattedTimeString() -> String {
        let minutes = Int(self / 60)
        let seconds = Int(self) % 60
        let fraction = Int((self.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%01d", minutes, seconds, fraction)
    }
}
