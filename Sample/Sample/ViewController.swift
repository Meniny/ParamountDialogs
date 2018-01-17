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
        imageView.kf.setImage(with: URL.init(string: "https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/68dd54ca-60cf-4ef7-898b-26d7cbe48ec7/10-dithering-opt.jpg"))
        
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        tapGesture.cancelsTouchesInView = true
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
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
    
    private func showDialog(queue: Bool = true, message m: String? = nil) {
        self.counter += 1
        
        let icon = URL.init(string: "https://www.google.co.jp/logos/doodles/2018/katy-jurados-94th-birthday-5562889569042432-l.png")
        let message = m ?? "Welcome, \(randomNames().joined(separator: ", "))!"
        
        var buttons: ParamountButtonInfoSet = []
        if queue {
            buttons.append(.filled("Show Another"))
        }
        buttons.append(.bordered("Cancel"))
        
        let textFields: ParamountTextFieldInfoSet
        if queue {
            textFields = []
        } else {
            textFields = [
                TextFieldType.normal("admin@meniny.cn", placeholder: "Username/E-mail", keyboard: .emailAddress),
                TextFieldType.security("12345678", placeholder: "Passcode", keyboard: .asciiCapable),
            ]
        }
        
        let dialog = ParamountDialog.make(dialog: queue ? "Dialog \(self.counter)" : "Avatar Tapped",
                                          message: message,
                                          alignment: .center,
                                          icon: .remote(icon),
                                          placeholder: nil,
                                          buttons: buttons,
                                          textFields: textFields,
                                          sound: .endRecord,
                                          blur: true) { [weak self] (d, btn) in
                                            if btn.title(for: .normal) == "Show Another" {
                                                self?.showDialog()
                                            }
                                            d.hide()
            }.onAvatarTapped { [weak self] (dialog, imageView) in
                self?.showDialog(queue: false, message: String.init(describing: dialog.avatar.source))
        }
        dialog.show(animated: true, to: self.view, wait: queue)
    }

}

