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
import PresentationSettings

/// The dialog view used in Paramount
open class ParamountDialog: UIViewController, PresentationSettingsDelegate {
    /// The title label
    open private(set) var titleLabel: ParamountLabel = ParamountLabel.init()
    /// The title text
    open var titleText: String = "Notification"
    
    /// The container of message container
    open private(set) var messageScroller: UIScrollView = UIScrollView.init()
    /// The container of message label
    open private(set) var messageContainer: UIView = UIView.init()
    /// The message label
    open private(set) var messageLabel: ParamountLabel = ParamountLabel.init()
    /// The message text
    open var messageText: String = ""
    /// The alignment of message text
    open private(set) var messageAlignment: NSTextAlignment = .center
    
    /// The container view of all subviews
    open private(set) var containerView: UIView = UIView.init()
    
    /// The background view
    open private(set) var backgroundView: UIView = UIView.init()
    
    /// The avatar view
    open private(set) var avatarView: UIImageView = UIImageView.init()
    /// The container of avatar view
    open private(set) var avatarContainerView: UIView = UIView.init()
    /// The avatar
    open var avatar: ImageType = .nil
    open var avatarSize: CGFloat = 100
    open var avatarBorderWidth: CGFloat = 3
    /// The avatar placeholder
    open var avatarPlaceholder: UIImage?
    
    open static var defaultAvatar: ImageType = .nil
    open static var defaultAvatarSize: CGFloat = 100
    open static var defaultAvatarBorderWidth: CGFloat = 3
    
    /// The avatar view tap action
    open private(set) var avatarClosure: ParamountAvatarActionClosure?
    
    /// The container view of avatar view, title & message label
    open private(set) var headerView: UIView = UIView.init()
    /// The container view of buttons
    open private(set) var footerView: UIView = UIView.init()
    /// The container view of other contents
    open private(set) var contentView: UIView = UIView.init()
    /// The custom view to display
    open private(set) var customView: UIView?
    
    /// A set of button configurations
    open private(set) var buttonInfoSet: [ButtonType] = []
    /// The buttons array
    open private(set) var buttons: [ParamountButton] = []
    /// The button tap action
    open private(set) var actionClosure: ParamountDialogActionClosure?
    open private(set) var genericSoundID: SystemSounds.IDs?
    
    /// A set of text filed configurations
    open private(set) var textFieldInfoSet: [TextFieldType] = []
    /// The text fields array
    open private(set) var textFields: [ParamountTextField] = []
    
    private var hasDefaultClosureButton = true
    
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
    
    private func configuration() {
        self.title = nil
        self.view.backgroundColor = UIColor.clear
        
        self.view.translates(subViews: self.containerView)
        
        self.containerView.width(kDialogWidth)
        self.containerView.top(>=8).bottom(>=8).left(>=8).right(>=8)
        self.containerView.centerInContainer()
        
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
        
        self.headerView.translates(subViews: self.titleLabel, self.messageScroller)
        self.headerView.layout(
            0,
            |-8-self.titleLabel.height(>=0)-8-|,
            8,
            |-8-self.messageScroller-8-|,
            0
        )
        
        self.messageScroller.style { (scroll) in
            scroll.showsVerticalScrollIndicator = true
            scroll.showsHorizontalScrollIndicator = false
            scroll.bounces = false
        }
        
        self.messageScroller.translates(subViews: self.messageContainer)
        self.messageContainer.left(0).right(0).top(0).bottom(0)
        
        self.messageContainer.translates(subViews: self.messageLabel)
        self.messageLabel.left(0).top(0).right(0).bottom(0).height(>=0)
        self.messageContainer.widthAttribute == self.messageScroller.widthAttribute
        //        self.messageScroller.height(<=100)//Attribute == self.messageContainer.heightAttribute
        
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
        
        let avatarLength = self.avatarSize
        let avatarBorder = self.avatarBorderWidth
        //: CGFloat = fmin(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.4
        self.avatarView.size(avatarLength)
        self.avatarView.style { (avatar) in
            avatar.clipsToBounds = true
            avatar.layer.masksToBounds = true
            avatar.layer.cornerRadius = avatarLength * 0.50
            avatar.layer.borderWidth = avatarBorder
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
        
        self.messageScroller.height(20)
        
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.clipsToBounds = true
        self.backgroundView.layer.cornerRadius = self.backgroundCornerRadius
        
        self.avatarView.setImage(self.avatar, placeholder: self.avatarPlaceholder)
        
        self.contentView.centerHorizontally()
        
        for field in self.textFieldInfoSet {
            self.addField(field.text, placeholder: field.placeholder, keyboardType: field.keyboardType, security: field.isSecureTextEntry)
        }
        self.textFields.last?.bottom(8)
        
        if !self.textFields.isEmpty {
            let dismissKeyboardTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
            self.view.addGestureRecognizer(dismissKeyboardTap)
            
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
        
        if let custom = self.customView {
            let lastSubView = self.contentView.subviews.last
            self.contentView.translates(subViews: custom)
            if let last = lastSubView {
                custom.topAttribute == last.bottomAttribute + 8
                custom.left(8).right(8).bottom(0)
            } else {
                self.contentView.layout(
                    0,
                    |-8-custom-8-|,
                    0
                )
            }
        }
        
        if self.hasDefaultClosureButton && self.buttonInfoSet.isEmpty {
            self.buttonInfoSet.append(.filled("Close"))
        }
        
        for btn in self.buttonInfoSet {
            let idx = self.buttonInfoSet.index(of: btn) ?? 0
            self.addAction(btn.title, style: btn.style, sound: self.genericSoundID, onTap: { (b) in
                //                guard let strongSelf = self else {
                //                    return
                //                }
                self.actionClosure?(self, b, idx)
            })
        }
        self.buttons.last?.bottom(0)
    }
    
    private let backgroundCornerRadius: CGFloat = 10
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*@objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let mainViewHeight = self.view.bounds.height
        let mainViewHalf = mainViewHeight * 0.5
        let keyboradHeight = keyboardframe.height
        let mainLeftHeight = mainViewHeight - keyboradHeight
        let containerHeight = self.containerView.bounds.height
        
        let extend = self.backgroundCornerRadius
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            let centerY: CGFloat
            if mainLeftHeight >= containerHeight {
                centerY = mainViewHalf - mainLeftHeight * 0.5
            } else {
                if keyboradHeight <= mainViewHalf {
                    centerY = mainViewHalf - (mainLeftHeight - containerHeight * 0.5)
                } else {
                    centerY = (keyboradHeight - mainViewHalf) + containerHeight * 0.5 + 8
                }
            }
            self?.containerView.centerYConstraint?.constant = -fabs(centerY)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        let extend = self.backgroundCornerRadius
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.containerView.centerYConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    */
    
    @objc
    private func dismissKeyboard() {
        self.resignFirstResponder()
        self.containerView.endEditing(true)
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
    
    @discardableResult
    private func addField(_ text: String?, placeholder: String?, keyboardType: UIKeyboardType, security: Bool) -> ParamountTextField {
        let textField = ParamountTextField.init(frame: .zero)
        textField.text = text
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = security
        
        let lastField = self.contentView.subviews.last
        self.contentView.translates(subViews: textField)
        
        let fieldHeight: CGFloat = 49
        let marginV: CGFloat = 8
        let marginH: CGFloat = 0
        
        textField.left(marginH).right(marginH).height(fieldHeight)
        
        if let last = lastField {
            textField.topAttribute == last.bottomAttribute + marginV
        } else {
            textField.top(marginV)
        }
        self.textFields.append(textField)
        
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: kDialogWidth, height: 50))
        toolBar.barStyle = .default
        let doneItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleItem, doneItem]
        
        textField.inputAccessoryView = toolBar
        toolBar.sizeToFit()
        
        
        return textField
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
                        style: ParamountButton.DisplayStyle,
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
    ///   - buttonSet: The buttons
    ///   - fieldSet: The text fields
    ///   - sound: The sound be played when button tapped
    ///   - blur: If blur background
    ///   - closure: Button tapped action
    /// - Returns: The dialog
    @discardableResult
    open class func make(_ titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         size iconSize: CGFloat = ParamountDialog.defaultAvatarSize,
                         border: CGFloat = ParamountDialog.defaultAvatarBorderWidth,
                         placeholder: UIImage? = nil,
                         buttons buttonSet: ParamountButtonInfoSet,
                         defaultButton: Bool = true,
                         textFields fieldSet: ParamountTextFieldInfoSet = [],
                         customView custom: UIView? = nil,
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         action closure: @escaping ParamountDialogActionClosure = ParamountDialogDefaultActionClosure) -> ParamountDialog {
        let dialog = ParamountDialog.init()
        dialog.titleText = NSLocalizedString(titleKey, comment: "")
        dialog.messageText = NSLocalizedString(messageKey, comment: "")
        dialog.messageAlignment = alignment
        dialog.avatar = icon
        dialog.avatarSize = iconSize
        dialog.avatarBorderWidth = border
        dialog.avatarPlaceholder = placeholder
        dialog.buttonInfoSet.append(contentsOf: buttonSet)
        dialog.textFieldInfoSet.append(contentsOf: fieldSet)
        dialog.hasDefaultClosureButton = defaultButton
        dialog.customView = custom
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
    ///   - buttonSet: The buttons
    ///   - fieldSet: The text fields
    ///   - sound: The sound be played when button tapped
    ///   - blur: If blur background
    ///   - closure: Button tapped action
    /// - Returns: The dialog
    @discardableResult
    open class func show(_ titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         size iconSize: CGFloat = ParamountDialog.defaultAvatarSize,
                         border: CGFloat = ParamountDialog.defaultAvatarBorderWidth,
                         placeholder: UIImage? = nil,
                         buttons buttonSet: ParamountButtonInfoSet,
                         defaultButton: Bool = true,
                         textFields fieldSet: ParamountTextFieldInfoSet = [],
                         customView custom: UIView? = nil,
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         to toViewController: UIViewController? = nil,
                         action closure: @escaping ParamountDialogActionClosure = ParamountDialogDefaultActionClosure) -> ParamountDialog {
        
        let dialog = ParamountDialog.make(titleKey,
                                          message: messageKey,
                                          alignment: alignment,
                                          icon: icon,
                                          size: iconSize,
                                          border: border,
                                          placeholder: placeholder,
                                          buttons: buttonSet,
                                          defaultButton: defaultButton,
                                          textFields: fieldSet,
                                          customView: custom,
                                          sound: sound,
                                          blur: blur,
                                          action: closure)
        
        dialog.show(animated: true, to: toViewController)
        return dialog
    }
    
    @discardableResult
    open class func make(loading titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         size iconSize: CGFloat = ParamountDialog.defaultAvatarSize,
                         border: CGFloat = ParamountDialog.defaultAvatarBorderWidth,
                         placeholder: UIImage? = nil,
                         buttons buttonSet: ParamountButtonInfoSet = [],
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         action closure: @escaping ParamountDialogActionClosure = ParamountDialogDefaultActionClosure) -> ParamountDialog {
        
        let indicatorContainer = UIView.init()
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicatorContainer.translates(subViews: indicator)
        indicatorContainer.height(50)
        indicator.centerInContainer()
        indicator.startAnimating()
        
        return self.make(titleKey,
                         message: messageKey,
                         alignment: alignment,
                         icon: icon,
                         size: iconSize,
                         border: border,
                         placeholder: placeholder,
                         buttons: buttonSet,
                         defaultButton: false,
                         textFields: [],
                         customView: indicatorContainer,
                         sound: sound,
                         blur: blur,
                         action: closure)
    }
    
    @discardableResult
    open class func show(loading titleKey: String,
                         message messageKey: String,
                         alignment: NSTextAlignment = .center,
                         icon: ImageType,
                         size iconSize: CGFloat = ParamountDialog.defaultAvatarSize,
                         border: CGFloat = ParamountDialog.defaultAvatarBorderWidth,
                         placeholder: UIImage? = nil,
                         buttons buttonSet: ParamountButtonInfoSet = [],
                         sound: SystemSounds.IDs? = nil,
                         blur: Bool = true,
                         to toViewController: UIViewController? = nil,
                         action closure: @escaping ParamountDialogActionClosure = ParamountDialogDefaultActionClosure) -> ParamountDialog {
        
        let loading = self.make(loading: titleKey,
                                message: messageKey,
                                alignment: alignment,
                                icon: icon,
                                size: iconSize,
                                border: border,
                                placeholder: placeholder,
                                buttons: buttonSet,
                                sound: sound,
                                blur: blur,
                                action: closure)
        loading.show(animated: true, to: toViewController, wait: true)
        return loading
    }
    
    open private(set) var shouldWaitInQueue: Bool = true
    
    /// Show this dialog in queue
    ///
    /// - Parameters:
    ///   - animated: If showing animated
    ///   - toViewController: Show to a UIViewController
    ///   - wait: If wait in queue
    open func show(animated: Bool = true, to toViewController: UIViewController? = nil, wait: Bool = true) {
        self.shouldWaitInQueue = wait
        DispatchQueue.main.async {
            if !wait {
                if let last = toViewController?.presentedViewController {
                    let completion: (() -> Void) = {
                        self.show_in_queue(true, animated: animated, to: toViewController)
                    }
                    if let lastDialog = last as? ParamountDialog {
                        lastDialog.hide(animated: true, completion: completion)
                    } else {
                        last.dismiss(animated: true, completion: completion)
                    }
                    return
                }
            }
            self.show_in_queue(true, animated: animated, to: toViewController)
        }
    }
    
    private func show_in_queue(_ queue: Bool, animated: Bool, to toViewController: UIViewController?) {
        let toController = toViewController ?? UIApplication.shared.keyWindow?.rootViewController
        guard let controller = toController else {
            fatalError("Nil view controller to show")
        }
        
        self.loadViewIfNeeded()
        self.updateMessageScroller()
        
        controller.present(viewController: self,
                           settings: self.presentationSettings,
                           animated: animated,
                           serial: queue,
                           completion: nil)
    }
    
    open lazy var presentationSettings: PresentationSettings = {
        let settings = PresentationSettings.default
        return settings
    }()
    
    /// Hide this dialog
    ///
    /// - Parameters:
    ///   - animated: If animated
    ///   - completion: Completion action
    open func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(fromSerial: true,//self.shouldWaitInQueue,
                     animated: animated,
                     completion: completion)
    }
    
    open var maxLineCount: UInt = 8
    
    private func updateMessageScroller() {
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        
        self.messageScroller.contentSize = self.messageLabel.bounds.size
        
        let maxHeight = messageLabel.font.lineHeight * CGFloat(self.maxLineCount)
        
        if self.messageScroller.contentSize.height >= maxHeight {
            self.messageScroller.heightConstraint?.constant = maxHeight
        } else {
            self.messageScroller.heightConstraint?.constant = self.messageScroller.contentSize.height
        }
    }
}

