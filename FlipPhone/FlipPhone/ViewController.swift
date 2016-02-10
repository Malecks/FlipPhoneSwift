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
        if motion.deviceMotion == nil // || flipModeRunning == false
        {
            return
        }
        //        if model.didRoll((motion.deviceMotion?.attitude)!) {
        //            rollsLabel.text = "\(model.rollCount)"
        //        }
        //        if model.didSpin((motion.deviceMotion?.attitude)!) {
        //            spinsLabel.text = "\(model.yawCount)"
        //        }
        //        if model.didFlip((motion.deviceMotion?.attitude)!) {
        //            flipsLabel.text = "\(model.pitchCount)"
        //        }
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
            flipModeRunning = true
            print("throwing!")
        }
        if didStartThrow && totalAcceleration < 1 {
            didStartThrow = false
            flipModeRunning = false
            print("stopped throw")
            
            // TODO: Animate Score on, then off. After animate off reset score
            calculateScore()
        }
    }
    
    func calculateScore() {
        if model.rollCount > 0 || model.yawCount > 0 || model.pitchCount > 0 {
            rollsLabel.text = "\(model.rollCount)"
            spinsLabel.text = "\(model.yawCount)"
            flipsLabel.text = "\(model.pitchCount)"
        }
        
        flipModeScore = ((model.rollCount * 45) + (model.yawCount * 65) + (model.pitchCount * 100))
        if flipModeScore > 0 {
            scoreLabel.text = "\(flipModeScore)"
        }
        model.rollCount = 0
        model.yawCount = 0
        model.pitchCount = 0
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








