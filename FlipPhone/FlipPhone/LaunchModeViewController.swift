//
//  LaunchModeViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-09.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

class LaunchModeViewController: UIViewController {
    // MARK: Variables
    @IBOutlet var timeLabel: UILabel!
    
    var launchModeRunning: Bool = false
    var startTime : CFAbsoluteTime!
    var motion = CMMotionManager()
    var didStartThrow: Bool = false
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.presentingViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Preparation
    
    // MARK: Timer and updates
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateAcceleration"), userInfo: nil, repeats: true)
    }
    
    
    func updateAcceleration() {
        if launchModeRunning == false {
            return
        }
        
                print("xyz:\(motion.accelerometerData?.acceleration.y, motion.accelerometerData?.acceleration.x, motion.accelerometerData?.acceleration.z)")
//        let aX = motion.accelerometerData?.acceleration.x
//        let aY = motion.accelerometerData?.acceleration.y
//        let aZ = motion.accelerometerData?.acceleration.z
//        let totalAcceleration = sqrt((aX! * aX!) + (aY! * aY!) + (aZ! * aZ!))
        
        let remainingTime = round((3.0 - (CFAbsoluteTimeGetCurrent() - startTime)) * 10) / 10
        print("\(remainingTime)")
        if remainingTime > 0 {
            timeLabel.text = "\(remainingTime)"
        } else {
            timeLabel.text = "0.0"
        }
        
//        if totalAcceleration > 4 {
//            didStartThrow = true
//            print("throwing!")
//        }
//        if didStartThrow && totalAcceleration < 1 {
//            didStartThrow = false
//            print("stopped throw")
//            
//            // TODO: Animate Score on, then off. After animate off reset score
//            
//        }
    }
    
    
    // MARK: Handlers
    @IBAction func flipModeButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startButton(sender: UIButton) {
        // start 3 second timer
        startTimer()
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "startStopLaunchMode", userInfo: nil, repeats: false)
        startStopLaunchMode()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func startStopLaunchMode () {
        launchModeRunning = !launchModeRunning
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
