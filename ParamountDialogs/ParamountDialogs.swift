//
//  ParamountDialogs.swift
//  Pods-ParamountDialogsSample-Sample
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
//  Created by Elias Abel on 2018/1/16.
//  
//

import Foundation
import UIKit
import JustLayout
import Kingfisher
import SystemSounds

private var kMaxDialogWidth: CGFloat = 280
private var kDialogMarginWidth: CGFloat = 16
private let kDuration: TimeInterval = 0.25
private var kDialogSemaphore = DispatchSemaphore.init(value: 1)
private var kDialogQueue = DispatchQueue.init(label: "ParamountDialogOrderQueue")

public typealias ParamountButtonTapActionClosure = (_ button: ParamountButton) -> Swift.Void
public typealias ParamountDialogActionClosure = (_ dialog: ParamountDialog, _ tapped: ParamountButton) -> Swift.Void
public typealias ParamountAvatarActionClosure = (_ dialog: ParamountDialog, _ avatar: UIImageView) -> Swift.Void

public typealias ParamountButtonSet = [(title: String, style: ParamountButton.DisplayStyle)]

/// The types of icon
///
/// - image: `UIImage` object
/// - named: Image name in `.xcassets`
/// - path: Image path in main bundle
/// - remote: Remote image URL
/// - `nil`: Just nil
public enum ImageType {
    case object(UIImage?)
    case named(String)
    case path(URL?)
    case remote(URL?)
    case `nil`
    
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

/// The dialog view used in Paramount
open class ParamountDialog: UIViewController {
    
    /// The title label
    open private(set) var titleLabel: ParamountLabel = ParamountLabel.init()
    /// The title text
    open var titleText: String = "Notification"
    
    /// The message label
    open private(set) var messageLabel: ParamountLabel = ParamountLabel.init()
    /// The message text
    open var messageText: String = ""
    /// The alignment of message text
    open private(set) var messageAlignment: NSTextAlignment = .center
    
    /// The container view of all subviews
    open private(set) var containerView: UIView = UIView.init()
    
    open private(set) lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let visualEffectView = UIVisualEffectView.init(effect: effect)
        return visualEffectView
    }()
    
    /// The background view
    open private(set) var backgroundView: UIView = UIView.init()
    
    /// The avatar view
    open private(set) var avatarView: UIImageView = UIImageView.init()
    /// The container of avatar view
    open private(set) var avatarContainerView: UIView = UIView.init()
    /// The avatar
    open var avatar: ImageType = .nil
    /// The avatar placeholder
    open var avatarPlaceholder: UIImage?
    /// The avatar view tap action
    open private(set) var avatarClosure: ParamountAvatarActionClosure?
    
    /// The container view of avatar view, title & message label
    open private(set) var headerView: UIView = UIView.init()
    /// The container view of buttons
    open private(set) var footerView: UIView = UIView.init()
    /// The container view of other contents
    open private(set) var contentView: UIView = UIView.init()
    
    /// A set of button configurations
    open private(set) var buttonSet: ParamountButtonSet = []
    /// The buttons array
    open private(set) var buttons: [ParamountButton] = []
    /// The button tap action
    open private(set) var actionClosure: ParamountDialogActionClosure?
    
    open private(set) var genericSoundID: SystemSounds.IDs?
    
    /// If blur background
    open var blurBackground: Bool = true
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("User the class method instead")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
    }
    
    
    private var superWidth: CGFloat = kMaxDialogWidth
    /// Subviews configuration
    private func configuration() {
        self.title = nil
        self.view.backgroundColor = UIColor.clear//init(white: 0, alpha: 0.25)
        
        self.view.translates(subViews: self.blurView, self.containerView)
        
        self.blurView.top(0).bottom(0).left(0).right(0)
        self.blurView.isHidden = !self.blurBackground
        
        let containerWidth = fmin(fmin(UIScreen.main.bounds.width, UIScreen.main.bounds.height), self.superWidth)
        self.containerView.centerInContainer().width(containerWidth).bottom(>=8).top(>=8)
        
        self.containerView.translates(subViews: self.backgroundView,
                                      self.avatarContainerView,
                                      self.headerView,
                                      self.contentView,
                                      self.footerView)
        self.containerView.layout(
            8,
            self.avatarContainerView,
            16,
            |-8-self.headerView.height(>=20)-8-|,
            0,
            |-8-self.contentView.height(>=8)-8-|,
            0,
            |-8-self.footerView.height(>=20)-8-|,
            8
        )
        self.avatarContainerView.aspect(ofWidth: 100%)
        self.avatarContainerView.centerHorizontally()
        
        self.backgroundView.topAttribute == self.avatarContainerView.centerYAttribute
        self.backgroundView.left(0).right(0).bottom(0)
        
        self.headerView.translates(subViews: self.titleLabel, self.messageLabel)
        self.headerView.layout(
            0,
            |-8-self.titleLabel.height(>=0)-8-|,
            8,
            |-8-self.messageLabel.height(>=0)-8-|,
            0
        )
        
        [self.titleLabel, self.messageLabel].style { (l) in
            l.textAlignment = .center
            l.clipsToBounds = true
            l.numberOfLines = 0
        }
        self.titleLabel.style { (l) in
            l.font = UIFont.boldSystemFont(ofSize: 18)
            l.textColor = UIColor.darkText
        }
        self.messageLabel.style { (l) in
            l.font = UIFont.systemFont(ofSize: 13)
            l.textColor = UIColor.lightGray
        }
        
        self.avatarContainerView.translates(subViews: self.avatarView)
        self.avatarContainerView.layout(
            0,
            |self.avatarView|,
            0
        )
        
        let avatarLength: CGFloat = fmin(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.4
        self.avatarView.size(avatarLength)
        self.avatarView.style { (avatar) in
            avatar.clipsToBounds = true
            avatar.layer.masksToBounds = true
            avatar.layer.cornerRadius = avatarLength * 0.50
            avatar.layer.borderWidth = 5
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.backgroundColor = UIColor.groupTableViewBackground
            avatar.contentMode = .scaleAspectFill
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(avatarTapped))
        tapGesture.cancelsTouchesInView = true
        tapGesture.numberOfTouchesRequired = 1
        self.avatarContainerView.addGestureRecognizer(tapGesture)
        
        self.titleLabel.text = self.titleText
        self.messageLabel.text = self.messageText
            
        self.messageLabel.textAlignment = self.messageAlignment
        
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.clipsToBounds = true
        self.backgroundView.layer.cornerRadius = 10
        
        self.avatarView.setImage(self.avatar, placeholder: self.avatarPlaceholder)
        
        if self.buttonSet.isEmpty {
            self.buttonSet.append(("Close", .filled))
        }
        
        for (btn, style) in self.buttonSet {
            self.addAction(btn, style: style, sound: self.genericSoundID, onTap: { (b) in
//                guard let strongSelf = self else {
//                    return
//                }
                self.actionClosure?(self, b)
            })
        }
        self.buttons.last?.bottom(0)
    }
    
    @objc
    private func avatarTapped() {
        self.avatarClosure?(self, self.avatarView)
    }
    
    @discardableResult
    open func onAvatarTapped(_ closure: @escaping ParamountAvatarActionClosure) -> ParamountDialog {
        self.avatarClosure = closure
        return self
    }
    
    /// Add an button to dialog, called before shown
    ///
    /// - Parameters:
    ///   - actionTitle: Button title
    ///   - style: Button style
    ///   - closure: Tapped action
    /// - Returns: The button itself
    @discardableResult
    private func addAction(_ actionTitle: String,
                        style: ParamountButton.DisplayStyle = .borderd,
                        sound: SystemSounds.IDs? = nil,
                        onTap closure: @escaping ParamountButtonTapActionClosure) -> ParamountButton {
        let button = ParamountButton.init(title: actionTitle, style: style, sound: sound, closure: closure)
        
        let lastButton = self.footerView.subviews.last
        
        self.footerView.translates(subViews: button)
        
        button.style { (b) in
            b.setTitleColor(style.titleColor, for: .normal)
            b.backgroundColor = style.backgroundColor
            b.clipsToBounds = true
            b.layer.cornerRadius = 5
            b.layer.borderColor = style.borderColor.cgColor
            b.layer.borderWidth = 2
        }
        
        let buttonHeight: CGFloat = 49
        let marginV: CGFloat = 8
        let marginH: CGFloat = 0
        
        button.left(marginH).right(marginH).height(buttonHeight)
        
        if let last = lastButton {
            button.topAttribute == last.bottomAttribute + marginV
        } else {
            button.top(0)
        }
        self.buttons.append(button)
        return button
    }
    
    /// Make a dialog instance
    ///
    /// - Parameters:
    ///   - titleKey: The key for localized title text
    ///   - messageKey: The key for localized message text
    ///   - alignment: Message text alignment
    ///   - icon: The icon image
    ///   - placeholder: The placeholder image
    ///   - buttonArray: The buttons
    ///   - sound: The sound be played when button tapped
    ///   - blur: If blur background
    ///   - closure: Button tapped action
    /// - Returns: The dialog
    @discardableResult
    open class func make(dialog titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         placeholder: UIImage? = nil,
                         buttons buttonArray: ParamountButtonSet,
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         action closure: @escaping ParamountDialogActionClosure) -> ParamountDialog {
        let dialog = ParamountDialog.init()
        dialog.titleText = NSLocalizedString(titleKey, comment: "")
        dialog.messageText = NSLocalizedString(messageKey, comment: "")
        dialog.messageAlignment = alignment
        dialog.avatar = icon
        dialog.avatarPlaceholder = placeholder
        dialog.buttonSet.append(contentsOf: buttonArray)
        dialog.genericSoundID = sound
        dialog.blurBackground = blur
        dialog.actionClosure = closure
        return dialog
    }
    
    /// Show a dialog
    ///
    /// - Parameters:
    ///   - titleKey: The key for localized title text
    ///   - messageKey: The key for localized message text
    ///   - alignment: Message text alignment
    ///   - icon: The icon image
    ///   - placeholder: The placeholder image
    ///   - buttonArray: The buttons
    ///   - sound: The sound be played when button tapped
    ///   - blur: If blur background
    ///   - closure: Button tapped action
    /// - Returns: The dialog
    @discardableResult
    open class func show(dialog titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         placeholder: UIImage? = nil,
                         buttons buttonArray: ParamountButtonSet,
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         to toView: UIView? = nil,
                         action closure: @escaping ParamountDialogActionClosure) -> ParamountDialog {
        
        let dialog = ParamountDialog.make(dialog: titleKey,
                                          message: messageKey,
                                          alignment: alignment,
                                          icon: icon,
                                          placeholder: placeholder,
                                          buttons: buttonArray,
                                          sound: sound,
                                          blur: blur,
                                          action: closure)
        
        dialog.show(animated: true, to: toView)
        return dialog
    }
    
    open private(set) var shouldWaitInQueue: Bool = true
    
    /// Show this dialog in queue
    ///
    /// - Parameters:
    ///   - animated: If showing animated
    ///   - toView: Show to a view
    open func show(animated: Bool = true, to toView: UIView? = nil, wait: Bool = true) {
        self.shouldWaitInQueue = wait
        if self.shouldWaitInQueue {
            kDialogQueue.async {
                kDialogSemaphore.wait()
                DispatchQueue.main.async {
                    self.private_show(animated: animated, to: toView ?? UIApplication.shared.keyWindow)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.private_show(animated: animated, to: toView ?? UIApplication.shared.keyWindow)
            }
        }
    }
    
    private func private_show(animated: Bool, to toView: UIView?) {
        guard let toView = toView else {
            fatalError("Nil view to show")
            return
        }
        if toView.bounds.width >= kDialogMarginWidth {
            if toView.bounds.width > kMaxDialogWidth {
                self.superWidth = kMaxDialogWidth
            } else {
                self.superWidth = toView.bounds.width - kDialogMarginWidth
            }
        } else {
            self.superWidth = kMaxDialogWidth
        }
        self.loadViewIfNeeded()
        
        toView.translates(subViews: self.view)
        toView.layout(
            0,
            |self.view|,
            0
        )
        
        self.view.updateConstraints()
        
        if animated {
            self.containerView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            UIView.animate(withDuration: kDuration, animations: { [weak self] in
                self?.containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self?.view.alpha = 1
                }, completion: { (f) in
            })
        }
    }
    
    /// Hide this dialog
    ///
    /// - Parameter animated: If animated
    open func hide(animated: Bool = true) {
        guard let _ = self.view.superview else {
            self.view.removeFromSuperview()
            if self.shouldWaitInQueue {
                kDialogSemaphore.signal()
            }
            return
        }
        if animated {
            self.containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.view.alpha = 1
            UIView.animate(withDuration: kDuration, animations: { [weak self] in
                self?.containerView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self?.view.alpha = 0
            }, completion: { [weak self] (f) in
                if f {
                    self?.view.removeFromSuperview()
                    if self?.shouldWaitInQueue == true {
                        kDialogSemaphore.signal()
                    }
                }
            })
        } else {
            self.view.removeFromSuperview()
            if self.shouldWaitInQueue {
                kDialogSemaphore.signal()
            }
        }
    }
}

/// The label used in `ParamoundDialog`
open class ParamountLabel: UILabel {
    
    private lazy var longpress: UILongPressGestureRecognizer = {
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(showMenu))
        long.cancelsTouchesInView = true
        long.numberOfTapsRequired = 1
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

/// The button for `ParamountDialog`
open class ParamountButton: UIButton {
    
    public enum DisplayStyle {
        case filled, borderd
        
        fileprivate static let mainColor: UIColor = UIColor(red: 0.66, green: 0.64, blue: 0.91, alpha: 1.00)
        fileprivate static let secondaryColor: UIColor = UIColor.white
        
        fileprivate var titleColor: UIColor {
            if self == .filled {
                return DisplayStyle.secondaryColor
            }
            return DisplayStyle.mainColor
        }
        
        fileprivate var backgroundColor: UIColor {
            if self == .borderd {
                return DisplayStyle.secondaryColor
            }
            return DisplayStyle.mainColor
        }
        
        fileprivate var borderColor: UIColor {
            if self == .borderd {
                return self.titleColor
            }
            return UIColor.clear
        }
    }
    
    open private(set) var actionClosure: ParamountButtonTapActionClosure
    open private(set) var style: ParamountButton.DisplayStyle
    open private(set) var soundID: SystemSounds.IDs? = nil
    
    public init(title: String,
                style: ParamountButton.DisplayStyle = .borderd,
                sound: SystemSounds.IDs? = nil,
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
        }) { [weak self] in
        }
    }
    
    @objc
    private func touchUpOutsideAction() {
        self.scale(down: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }) { [weak self] in
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
        UIView.animate(withDuration: 0.1, animations: down) { [weak self] (f) in
            if f {
                reset()
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension UIImageView {
    fileprivate func setImage(_ imageType: ImageType, placeholder: UIImage?) {
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





