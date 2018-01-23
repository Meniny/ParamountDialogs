//
//  Label.swift
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

/// The label used in `ParamoundDialog`
open class ParamountLabel: UILabel {
    
    private lazy var longpress: UILongPressGestureRecognizer = {
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(showMenu))
        long.cancelsTouchesInView = false
        //        long.numberOfTapsRequired = 1
        return long
    }()
    
    private func makeSelectable() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(self.longpress)
    }
    
    public init() {
        super.init(frame: .zero)
        self.makeSelectable()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeSelectable()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeSelectable()
    }
    
    @objc
    private func showMenu() {
        if !UIMenuController.shared.isMenuVisible {
            self.becomeFirstResponder()
            UIMenuController.shared.setTargetRect(self.bounds, in: self)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let _ = self.text else {
            return false
        }
        return action == #selector(UIResponderStandardEditActions.copy(_:))
    }
    
    open override var canBecomeFirstResponder: Bool {
        guard let _ = self.text else {
            return false
        }
        return true
    }
    
    open override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
}
