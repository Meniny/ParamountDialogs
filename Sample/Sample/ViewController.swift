//
//  ViewController.swift
//  Sample
//
//  Created by 李二狗 on 2018/1/16.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import ParamountDialogs
import SystemSounds
import JustLayout
import Kingfisher

class ViewController: UIViewController {

    let some = UIView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        some.backgroundColor = UIColor.red
        view.translates(subViews: some)
        some.centerInContainer()
        some.width(80%).height(80%)
        
        let imageView = UIImageView.init()
        some.translates(subViews: imageView)
        imageView.centerInContainer()
        imageView.size(100%)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.kf.setImage(with: icon)
        
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        tapGesture.cancelsTouchesInView = true
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        let loading = ParamountDialog.show(loading: "Loading...", message: "Please wait 5 seconds.", icon: .remote(icon), size: 80, border: 3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {// [weak loading] in
            loading.hide()
        }
    }
    
    @objc
    private func tapped() {
        self.showDialog()
    }
    
    private var counter = 0
    private let contents: [String] = [
        "Abe",
        "Bob",
        "Caroline",
        "Daniel",
        "Elias",
        "Frank",
        "Green",
        "Howard"
    ]
    
    private func randomNames() -> [String] {
        var result = [String]()
        while true {
            let index = Int(arc4random_uniform(UInt32(self.contents.count)))
            let name = self.contents[index]
//            if !result.contains(name) {
                result.append(name)
//            }
            if result.count >= 100 {
                break
            }
        }
        return result
    }
    
    let icon = URL.init(string: "https://www.google.co.jp/logos/doodles/2018/katy-jurados-94th-birthday-5562889569042432-l.png")
    
    private func showDialog(queue: Bool = true, message m: String? = nil) {
        self.counter += 1
        let message = m ?? "Welcome, \(randomNames().joined(separator: ", "))!"
        var buttons: ParamountButtonInfoSet = []
        if queue {
            buttons.append(.filled("Show Another Dialog"))
        }
        buttons.append(.bordered("Cancel"))
        
        let textFields: ParamountTextFieldInfoSet
        if queue {
            textFields = [
                TextFieldType.normal("Elias Abel", placeholder: "Author", keyboard: .emailAddress),
            ]
        } else {
            textFields = [
                TextFieldType.normal("admin@meniny.cn", placeholder: "Username/E-mail", keyboard: .emailAddress),
                TextFieldType.secure("12345678", placeholder: "Passcode", keyboard: .asciiCapable),
            ]
        }
        
        let dialog = ParamountDialog.make(queue ? "Dialog \(self.counter)" : "Avatar Tapped",
                                          message: message,
                                          alignment: .center,
                                          icon: .remote(icon),
                                          size: 80,
                                          border: 3,
                                          placeholder: nil,
                                          buttons: buttons,
                                          textFields: textFields,
                                          sound: .endRecord,
                                          blur: true) { [weak self] (d, btn, i) in
                                            if btn.title(for: .normal) == "Show Another Dialog" {
                                                self?.anotherDialog(message)
                                            }
                                            d.hide()
            }.onAvatarTapped { [weak self] (dialog, imageView) in
                self?.showDialog(queue: false, message: String.init(describing: dialog.avatar.source))
        }
        
        dialog.hiddingAction = {
            print("HIDDING")
        }
        
        dialog.show(animated: true, to: self, wait: queue)
    }
    
    private func anotherDialog(_ message: String) {
        let dialog = ParamountDialog.make("Another Dialog",
                                          message: message,
                                          alignment: .center,
                                          icon: .remote(icon),
                                          size: 80,
                                          border: 3,
                                          placeholder: nil,
                                          buttons: [.filled("Send e-mail"), .bordered("Not now")],
                                          textFields: [.normal("admin@meniny.cn", placeholder: "Username/E-mail", keyboard: .emailAddress)],
                                          sound: .endRecord,
                                          blur: true) { (d, btn, i) in
                                            d.hide()
            }
        dialog.show(animated: true, to: self, wait: true)
    }

}

