//
//  IntroViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var patternView: PatternView!
    @IBOutlet var logoView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fade in pattern view
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.patternView.alpha = 1.0
            self.patternView.frame.origin.y -= self.view.frame.size.height
            }, completion: {
                (finished: Bool) -> Void in
                // Fade out logo view
                UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.logoView.alpha = 0.0
                    self.logoView.frame.size.height = 0
                    self.logoView.frame.size.width = 0
                    self.logoView.frame.origin = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
                    }, completion: {
                        (finished: Bool) -> Void in
                        // perform segue
                        self.performSegueWithIdentifier("flipMode", sender: self)
                })
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
