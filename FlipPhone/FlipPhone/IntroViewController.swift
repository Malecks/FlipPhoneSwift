//
//  IntroViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class IntroViewController: UIViewController {
    
    @IBOutlet fileprivate var patternView: PatternView!
    @IBOutlet fileprivate var logoView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                self.patternView.alpha = 1.0
                self.patternView.frame.origin.y -= self.view.frame.size.height
        },
            completion: { (finished: Bool) -> Void in
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.5,
                    options: UIViewAnimationOptions.curveEaseIn,
                    animations: {
                        self.logoView.alpha = 0.0
                        self.logoView.frame.size.height = 0
                        self.logoView.frame.size.width = 0
                        self.logoView.frame.origin = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
                },
                    completion: { (finished: Bool) -> Void in
                        self.performSegue(withIdentifier: "flipMode", sender: self)
                })
        })
    }
}
