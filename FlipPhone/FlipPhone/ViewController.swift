//
//  ViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-08.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    // MARK: Variables
    let motion = CMMotionManager()
    let model = RotationsModel()
    
    var flipModeScore = 0
    var didStartThrow: Bool = false
    var flipModeRunning: Bool = false
    
    @IBOutlet var spinsLabel: UILabel!
    @IBOutlet var flipsLabel: UILabel!
    @IBOutlet var rollsLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareCoreMotion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLabels()
        startTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        motion.stopDeviceMotionUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Preparation
    func prepareLabels() {
        rollsLabel.text = "\(model.rollCount)"
        spinsLabel.text = "\(model.yawCount)"
        flipsLabel.text = "\(model.pitchCount)"
        scoreLabel.text = "\(flipModeScore)"
    }
    
    func prepareCoreMotion() {
        if motion.deviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)
            
            // not sure if necessary on top of motion updates
            motion.accelerometerUpdateInterval = 0.01
            motion.startAccelerometerUpdates()
        }
    }
    
    // MARK: Timer and related functions
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateMotion"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateAcceleration"), userInfo: nil, repeats: true)
    }
    
    func updateMotion() {
        if motion.deviceMotion == nil {
            return
        }
        model.didRoll((motion.deviceMotion?.attitude)!)
        model.didSpin((motion.deviceMotion?.attitude)!)
        model.didFlip((motion.deviceMotion?.attitude)!)
        
    }
    
    func updateAcceleration() {
        //        print("xyz:\(motion.accelerometerData?.acceleration.y, motion.accelerometerData?.acceleration.x, motion.accelerometerData?.acceleration.z)")
        let aX = motion.accelerometerData?.acceleration.x
        let aY = motion.accelerometerData?.acceleration.y
        let aZ = motion.accelerometerData?.acceleration.z
        let totalAcceleration = sqrt((aX! * aX!) + (aY! * aY!) + (aZ! * aZ!))
        
        if totalAcceleration > 4 {
            didStartThrow = true
            print("throwing!")
        }
        if didStartThrow && totalAcceleration < 1 {
            didStartThrow = false
            print("stopped throw")
            calculateScore()
        }
    }
    
    func calculateScore() {
        if model.rollCount > 0 || model.yawCount > 0 || model.pitchCount > 0 {
            rollsLabel.text = "\(model.rollCount)"
            spinsLabel.text = "\(model.yawCount)"
            flipsLabel.text = "\(model.pitchCount)"
        }
        
        flipModeScore = ((model.rollCount * 70) + (model.yawCount * 115) + (model.pitchCount * 175))
        if flipModeScore > 0 {
            UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scoreLabel.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    //Once the label is completely invisible, set the text and fade it back in
                    self.scoreLabel.text = "\(self.flipModeScore)"
                    
                    // Fade in
                    UIView.animateWithDuration(0.65, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.scoreLabel.alpha = 1.0
                        }, completion: {(finished: Bool) -> Void in
                            self.model.rollCount = 0
                            self.model.yawCount = 0
                            self.model.pitchCount = 0
                    })
            })
        }
    }
    
    // MARK: Handlers
    @IBAction func resetButton() {
        model.rollCount = 0
        model.yawCount = 0
        model.pitchCount = 0
        rollsLabel.text = "\(model.rollCount)"
        flipsLabel.text = "\(model.pitchCount)"
        spinsLabel.text = "\(model.yawCount)"
        calculateScore()
        scoreLabel.text = "\(flipModeScore)"
    }
    
}








