//
//  ViewController.swift
//  FlashChat
//
//  Created by Sai Reddy on 13/08/21.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
        // Do any additional setup after loading the view.
//        let title = "⚡️FlashChat"
//        var charIndex = 0.0
//        titleLabel.text = ""
//        for i in title{
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
//                self.titleLabel.text?.append(i)
//            }
//            charIndex += 1
//        }
    }


}

