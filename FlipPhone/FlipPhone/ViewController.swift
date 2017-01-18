//
//  ViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-08.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

final class ViewController: UIViewController {
    
    // MARK: Variables
    fileprivate let motion = CMMotionManager()
    fileprivate let model = RotationsModel()
    
    fileprivate let topPatternView: PatternView = PatternView()
    
    fileprivate var flipModeScore = 0
    fileprivate var didStartThrow: Bool = false
    fileprivate var flipModeRunning: Bool = false
    
    @IBOutlet fileprivate var spinsLabel: UILabel!
    @IBOutlet fileprivate var flipsLabel: UILabel!
    @IBOutlet fileprivate var rollsLabel: UILabel!
    @IBOutlet fileprivate var scoreLabel: UILabel!
    
    // MARK: View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topPatternView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view .addSubview(topPatternView)
        view .addSubview(topPatternView)
        prepareCoreMotion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLabels()
        startTimer()
        fadeOutTopPattern()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        motion.stopDeviceMotionUpdates()
        motion.stopAccelerometerUpdates()
    }
    
    // MARK: Preparation
    func prepareLabels() {
        rollsLabel.text = "\(model.rollCount)"
        spinsLabel.text = "\(model.yawCount)"
        flipsLabel.text = "\(model.pitchCount)"
    }
    
    func prepareCoreMotion() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical)
            
            motion.accelerometerUpdateInterval = 0.01
            motion.startAccelerometerUpdates()
        }
    }
    
    // MARK: Timer and related functions
    func startTimer() {
        Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(ViewController.updateMotion),
            userInfo: nil,
            repeats: true
        )
        
        Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(ViewController.updateAcceleration),
            userInfo: nil,
            repeats: true
        )
    }
    
    func updateMotion() {
        guard motion.deviceMotion != nil else { return }
        
        model.checkRoll((motion.deviceMotion?.attitude)!)
        model.checkSpin((motion.deviceMotion?.attitude)!)
        model.checkFlip((motion.deviceMotion?.attitude)!)
    }
    
    func updateAcceleration() {
        guard motion.isAccelerometerAvailable else { return }

        let aX = motion.accelerometerData?.acceleration.x
        let aY = motion.accelerometerData?.acceleration.y
        let aZ = motion.accelerometerData?.acceleration.z
        let totalAcceleration = sqrt((aX! * aX!) + (aY! * aY!) + (aZ! * aZ!))
        
        if totalAcceleration > 4 {
            didStartThrow = true
        }
        if didStartThrow && totalAcceleration < 1 {
            didStartThrow = false
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
            UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scoreLabel.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    self.scoreLabel.text = "\(self.flipModeScore)"
                    UIView.animate(withDuration: 0.65, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
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
    
    
    // MARK: Animation
    func fadeOutTopPattern () {
        UIView.animate(withDuration: 1.5, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.topPatternView.alpha = 0.0 }, completion: nil)}
}








