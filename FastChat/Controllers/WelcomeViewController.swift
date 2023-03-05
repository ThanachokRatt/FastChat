//
//  ViewController.swift
//  FastChat
//
//  Created by Schweppe on 4/3/2566 BE.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = K.appName
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
                
            }
            charIndex += 1
            // Do any additional setup after loading the view.
        }
        
    }
}

