//
//  Define.swift
//  JustLayout
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
import JustLayout
import Kingfisher
import SystemSounds
import PresentationSettings

internal var kDialogWidth: CGFloat = PresentationSettings.suggestedViewWidth
internal var kDialogMarginWidth: CGFloat = 16
internal let kDuration: TimeInterval = 0.25

public typealias ParamountButtonTapActionClosure = (_ button: ParamountButton) -> Swift.Void
public typealias ParamountDialogActionClosure = (_ dialog: ParamountDialog, _ tapped: ParamountButton) -> Swift.Void
public typealias ParamountAvatarActionClosure = (_ dialog: ParamountDialog, _ avatar: UIImageView) -> Swift.Void

/// The types of icon
///
/// - image: `UIImage` object
/// - named: Image name in `.xcassets`
/// - path: Image path in main bundle
/// - remote: Remote image URL
/// - `nil`: Just nil
public enum ImageType: Equatable {
    case object(UIImage?)
    case named(String)
    case path(URL?)
    case remote(URL?)
    case `nil`
    
    public static func ==(lhs: ImageType, rhs: ImageType) -> Bool {
        switch (lhs, rhs) {
        case let (.object(a), .object(b)): return a == b
        case let (.named(a), .named(b)): return a == b
        case let (.path(a), .path(b)): return a == b
        case let (.remote(a), .remote(b)): return a == b
        case (.nil, .nil): return true
        default: return false
        }
    }
    
    public var source: Any? {
        switch self {
        case .object(let img):
            return img
        case .named(let name):
            return name
        case .path(let path):
            return path
        case .remote(let url):
            return url
        default:
            return nil
        }
    }
    
    /// Cannot return the remote image limitedly
    public var image: UIImage? {
        switch self {
        case .object(let img):
            return img
        case .named(let name):
            return UIImage.init(named: name)
        case .path(let path):
            guard let path = path else {
                return nil
            }
            return UIImage.init(contentsOfFile: path.path)
        case .remote(let url):
            if let url = url {
                ImageDownloader.default.downloadImage(with: url)
            }
            return nil
        default:
            return nil
        }
    }
}

internal extension UIImageView {
    internal func setImage(_ imageType: ImageType, placeholder: UIImage?) {
        switch imageType {
        case .remote(let url):
            self.kf.setImage(with: url,
                             placeholder: placeholder,
                             options: nil, progressBlock: nil, completionHandler: nil)
            break
        default:
            self.image = imageType.image ?? placeholder
            break
        }
    }
}

public var ParamountDialogDefaultActionClosure: ParamountDialogActionClosure {
    let c: ParamountDialogActionClosure =  { d, b in
        d.hide()
    }
    return c
}
