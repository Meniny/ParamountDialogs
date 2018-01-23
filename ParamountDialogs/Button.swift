//
//  Button.swift
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
import SystemSounds

public enum ButtonType: Equatable {
    case filled(String)
    case bordered(String)
    
    public static func ==(lhs: ButtonType, rhs: ButtonType) -> Bool {
        switch (lhs, rhs) {
        case let (.filled(tl), .filled(tr)):
            return tl == tr
        case let (.bordered(tl), .bordered(tr)):
            return tl == tr
        default: return false
        }
    }
    
    public var title: String {
        switch self {
        case .filled(let t):
            return t
        case .bordered(let t):
            return t
        }
    }
    
    public var style: ParamountButton.DisplayStyle {
        switch self {
        case .filled(_):
            return .filled
        case .bordered(_):
            return .bordered
        }
    }
}

public typealias ParamountButtonInfoSet = [ButtonType]

/// The button for `ParamountDialog`
open class ParamountButton: UIButton {
    
    public enum DisplayStyle {
        case filled, bordered
        
        internal static let mainColor: UIColor = UIColor(red: 0.66, green: 0.64, blue: 0.91, alpha: 1.00)
        internal static let secondaryColor: UIColor = UIColor.white
        
        internal var titleColor: UIColor {
            if self == .filled {
                return DisplayStyle.secondaryColor
            }
            return DisplayStyle.mainColor
        }
        
        internal var backgroundColor: UIColor {
            if self == .bordered {
                return DisplayStyle.secondaryColor
            }
            return DisplayStyle.mainColor
        }
        
        internal var borderColor: UIColor {
            if self == .bordered {
                return self.titleColor
            }
            return UIColor.clear
        }
    }
    
    open internal(set) var actionClosure: ParamountButtonTapActionClosure
    open internal(set) var style: ParamountButton.DisplayStyle
    open internal(set) var soundID: SystemSounds.IDs? = nil
    
    public init(title: String,
                style: ParamountButton.DisplayStyle,
                sound: SystemSounds.IDs?,
                closure: @escaping ParamountButtonTapActionClosure) {
        self.style = style
        self.soundID = sound
        self.actionClosure = closure
        super.init(frame: .zero)
        self.setTitle(NSLocalizedString(title, comment: ""), for: .normal)
        self.addTarget(self, action: #selector(touchDownAction), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUpOutsideAction), for: .touchUpOutside)
    }
    
    @objc
    private func touchDownAction() {
        if let sound = self.soundID {
            SystemSounds.play(sound: sound, isAlert: false, completion: nil)
        }
        self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        self.scale(down: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {
        }
    }
    
    @objc
    private func touchUpOutsideAction() {
        self.scale(down: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }) {
        }
    }
    
    @objc
    private func touchUpInsideAction() {
        self.scale(down: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            self?.actionClosure(strongSelf)
        }
    }
    
    private func scale(down: @escaping () -> Void, reset: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: down) { (f) in
            if f {
                reset()
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
