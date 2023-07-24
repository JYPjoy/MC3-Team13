//
//  FontManager.swift
//  MalBal
//
//  Created by Joy on 2023/07/24.
//

import Foundation
import SwiftUI

struct FontManager {
    /// 폰트 싱글톤 객체 생성
    static let shared = FontManager()

    /// 애플산돌고딕폰트의 타입 정의
    enum AppleSDGothicNeo: String {
        case extrabold = "EB"
        case semibold = "SB"
        case bold = "B"
        case medium = "M"
        case regular = "R"
    }

    /// 애플산돌고딕폰트의  type, size에 따라 return해 줍니다
    /// - Parameter Request: type , size
    /// - Returns: 나눔스퀘어라운드폰트의  type, size에 따른 커스텀 폰트 생성
    func nanumsquare(_ type:  AppleSDGothicNeo, _ size: CGFloat) -> Font {
        let name = "AppleSDGothicNeo" + type.rawValue
        return Font.custom(name, size: size)
    }
}

