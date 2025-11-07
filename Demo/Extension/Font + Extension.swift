//
//  Font + Extension.swift
//  AMAN
//
//  Created by iMac on 04/08/25.
//
import SwiftUI

enum AppFontSize: CGFloat, CaseIterable {
    // Custom sizes
    case _12 = 12
    case _13 = 13
    case _13_5 = 13.5
    case _14 = 14
    case _15 = 15
    case _16 = 16
    case _17 = 17
    case _18 = 18
    case _19 = 19
    case _20 = 20
    case _21 = 21
    case _22 = 22
    case _24 = 24
    case _25 = 25
    case _26 = 26
    case _27 = 27
    case _28 = 28
    case _29 = 29
    case _30 = 30
    case _32 = 32
    case _33 = 33
    
    // Responsive size based on device
    var responsive: CGFloat {
        return  rawValue
    }
    
    var iPhoneSize : CGFloat{
        return rawValue
    }
    // iPad scaling factor (you can adjust this multiplier)
    private var iPadSize: CGFloat {
        switch self {
        case ._18: return 25
        case ._19: return 26
        case ._21: return 28
        case ._24: return 30
        case ._25: return 31
        case ._26: return 32
        case ._27: return 37
        case ._29: return 39
        case ._30: return 40
        case ._32: return 42
        case ._33: return 43
        case ._13: return 23
        case ._13_5: return 23.5
        case ._14: return 24
        case ._15: return 25
        case ._16: return 26
        case ._17: return 27
        case ._12: return 12
        case ._28: return 28
        case ._20: return 20
        case ._22: return 22
        }
    }
}

extension Font{
    static func regular(size : AppFontSize)-> Font {
        return Font.custom("Graphik-Reular", size: size.responsive)
    }
    static func medium(size : AppFontSize)-> Font {
        return Font.custom("Graphik-Medium", size: size.responsive)
    }
    
    
}

