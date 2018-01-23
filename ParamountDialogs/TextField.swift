//
//  TextField.swift
//  ParamountDialogs
//
//  Blog  : https://meniny.cn
//  Github: https://github.com/Meniny
//
//  No more shall we pray for peace
//  Never ever ask them why
//  No more shall we stop their visions
//  Of selfdestructing genocide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  Screams of terror, panic spreads
//  Bombs are raining from the sky
//  Bodies burning, all is dead
//  There's no place left to hide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  (A voice was heard from the battle field)
//
//  "Couldn't care less for a last goodbye
//  For as I die, so do all my enemies
//  There's no tomorrow, and no more today
//  So let us all fade away..."
//
//  Upon this ball of dirt we lived
//  Darkened clouds now to dwell
//  Wasted years of man's creation
//  The final silence now can tell
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  When I wrote this code, only I and God knew what it was.
//  Now, only God knows!
//
//  So if you're done trying 'optimize' this routine (and failed),
//  please increment the following counter
//  as a warning to the next guy:
//
//  total_hours_wasted_here = 0
//
//  Created by Elias Abel on 2018/1/23.
//  
//

import Foundation
import UIKit

public enum TextFieldType: Equatable {
    case normal(String?, placeholder: String?, keyboard: UIKeyboardType)
    case secure(String?, placeholder: String?, keyboard: UIKeyboardType)
    
    public static func ==(lhs: TextFieldType, rhs: TextFieldType) -> Bool {
        switch (lhs, rhs) {
        case let (.normal(tl, pl, kl), .normal(tr, pr, kr)):
            return tl == tr && pl == pr && kl == kr
        case let (.secure(tl, pl, kl), .secure(tr, pr, kr)):
            return tl == tr && pl == pr && kl == kr
        default: return false
        }
    }
    
    public var isSecureTextEntry: Bool {
        switch self {
        case .normal(_, _, _):
            return false
        case .secure(_, _, _):
            return true
        }
    }
    
    public var text: String? {
        switch self {
        case .normal(let t, _, _):
            return t
        case .secure(let t, _, _):
            return t
        }
    }
    
    public var placeholder: String? {
        switch self {
        case .normal(_, let p, _):
            return p
        case .secure(_ , let p, _):
            return p
        }
    }
    
    public var keyboardType: UIKeyboardType {
        switch self {
        case .normal(_, _, let k):
            return k
        case .secure(_, _, let k):
            return k
        }
    }
}

public typealias ParamountTextFieldInfoSet = [TextFieldType]

open class ParamountTextField: UITextField {
    
}
