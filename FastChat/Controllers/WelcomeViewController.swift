//
//  ViewController.swift
//  FastChat
//
//  Created by Schweppe on 4/3/2566 BE.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }//ทำให้หน้า welcomewไม่มี Navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }//ทำให้หน้าอื่นๆแสดงnavigationBar หน้าไม่มีบรรทัดนี้ navigationBarจะหายไปทุกหน้าเพราะคำสั่งด้านบน
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

