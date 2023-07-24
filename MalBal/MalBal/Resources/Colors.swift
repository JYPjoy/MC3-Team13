//
//  Colors.swift
//  MalBal
//
//  Created by Joy on 2023/07/24.
//

import SwiftUI

extension Color {
    // MARK: - mainColor
    /// #EEB560
    static let main1 = Color(#colorLiteral(red: 0.9333333333, green: 0.7098039216, blue: 0.3764705882, alpha: 1))
    /// #052E37
    static let main2 = Color(#colorLiteral(red: 0.01960784314, green: 0.1803921569, blue: 0.2156862745, alpha: 1))
    /// #126149
    static let main3 = Color(#colorLiteral(red: 0.07058823529, green: 0.3803921569, blue: 0.2862745098, alpha: 1))
    /// #1E434B
    static let main4 = Color(#colorLiteral(red: 0.1176470588, green: 0.262745098, blue: 0.2941176471, alpha: 1))
    /// #EE6060
    static let main5 = Color(#colorLiteral(red: 0.9333333333, green: 0.3764705882, blue: 0.3764705882, alpha: 1))
    /// #49BA68
    static let main6 = Color(#colorLiteral(red: 0.2862745098, green: 0.7294117647, blue: 0.4078431373, alpha: 1))
    
    
    // MARK: 그 외 기타 컬러 코드 추출
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
