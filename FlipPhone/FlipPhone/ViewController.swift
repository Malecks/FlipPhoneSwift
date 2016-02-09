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
    
    @IBOutlet var spinsLabel: UILabel!
    @IBOutlet var flipsLabel: UILabel!
    @IBOutlet var rollsLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var flipModeScore = 0
    var flipModeRunning: Bool = false
    var startTime : CFAbsoluteTime!
    
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
        }
    }
    
    // MARK: Timer and related functions
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateMotion"), userInfo: nil, repeats: true)
    }
    
    func updateMotion() {
        if motion.deviceMotion == nil || flipModeRunning == false {
            return
        }
        if model.didRoll((motion.deviceMotion?.attitude)!) {
            rollsLabel.text = "\(model.rollCount)"
        }
        if model.didSpin((motion.deviceMotion?.attitude)!) {
            spinsLabel.text = "\(model.yawCount)"
        }
        if model.didFlip((motion.deviceMotion?.attitude)!) {
            flipsLabel.text = "\(model.pitchCount)"
        }
        calculateScore()
        scoreLabel.text = "\(flipModeScore)"
        
        let remainingTime = round((3.0 - (CFAbsoluteTimeGetCurrent() - startTime)) * 10) / 10
        print("\(remainingTime)")
    }
    
    func calculateScore() {
        flipModeScore = ((model.rollCount * 10) + (model.yawCount * 35) + (model.pitchCount * 50))
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
    
    @IBAction func startButton(sender: UIButton) {
        // start 3 second timer
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "startStopFlipMode", userInfo: nil, repeats: false)
        startStopFlipMode()
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func startStopFlipMode () {
        flipModeRunning = !flipModeRunning
    }
}








