//
//  LaunchModeViewController.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-09.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

final class LaunchModeViewController: UIViewController {
    // MARK: Variables
    @IBOutlet fileprivate var timeLabel: UILabel!
    @IBOutlet fileprivate var distanceFallenLabel: UILabel!
    
    fileprivate var launchModeRunning: Bool = false
    fileprivate var startTime : CFAbsoluteTime!
    fileprivate var motion = CMMotionManager()
    fileprivate var didStartThrow: Bool = false
    fileprivate var startTimeOfFreefall: CFAbsoluteTime = 0.0
    fileprivate var endTimeOfFreefall: CFAbsoluteTime = 0.0
    fileprivate var timeInFreefall: Float = 0
    fileprivate var bestTimeInFreefall: Float = 0
    fileprivate var distanceFallen: Float = 0
    
    
    // MARK: View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCoreMotion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        motion.stopDeviceMotionUpdates()
        motion.stopAccelerometerUpdates()
    }
    
    // MARK: Preparation
    fileprivate func prepareCoreMotion() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical)
            if motion.isAccelerometerAvailable {
                motion.accelerometerUpdateInterval = 0.01
                motion.startAccelerometerUpdates()
            }
        }
    }
    
    // MARK: Timer and updates
    fileprivate func startTimer() {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LaunchModeViewController.updateGravity), userInfo: nil, repeats: true)
        //        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateAcceleration"), userInfo: nil, repeats: true)
    }
    
    
    @objc fileprivate func updateGravity() {
        if motion.isDeviceMotionActive == false || launchModeRunning == false {
            return
        }
        // check if gravity is close enough to 0 to be considered freefall
        let gX = motion.accelerometerData?.acceleration.x
        let gY = motion.accelerometerData?.acceleration.y
        let gZ = motion.accelerometerData?.acceleration.z
        let totalGravity = sqrt((gX! * gX!) + (gY! * gY!) + (gZ! * gZ!))
        
        if totalGravity < 0.2 && totalGravity > -0.2 {
            
            // get time at start of freefall
            if !didStartThrow, startTimeOfFreefall == 0 {
                startTimeOfFreefall = CFAbsoluteTimeGetCurrent()
                didStartThrow = true
            }
        }
        
        // get end time when out of freefall
        if didStartThrow && totalGravity > 0.3 { // if gravity.z leaves freefall (resting is around -1)
            if endTimeOfFreefall == 0 {
                endTimeOfFreefall = CFAbsoluteTimeGetCurrent()
                let timeDifference: CFTimeInterval = compareTimes()
                let newDistance = calcDistance(Float(timeDifference))
                if newDistance > distanceFallen {
                    distanceFallen = newDistance
                }
                didStartThrow = false
            }
        }
        
        // update time label
        let remainingTime = round((3.0 - (CFAbsoluteTimeGetCurrent() - startTime)) * 100) / 100
        timeLabel.text = remainingTime > 0 ? "\(remainingTime)" : "0.0"
    }
    
    // MARK: Handlers
    @IBAction fileprivate func flipModeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func startButton(_ sender: UIButton) {
        startTimer()
        launchModeRunning = true
        Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(LaunchModeViewController.stopLaunchMode),
            userInfo: nil,
            repeats: false
        )
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    @objc fileprivate func stopLaunchMode () {
        if launchModeRunning {
            UIView.animate(
                withDuration: 0.35,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    self.distanceFallenLabel.alpha = 0.0
                },
                completion: { (finished: Bool) -> Void in
                    self.distanceFallenLabel.text = "\(self.distanceFallen)m"
                    UIView.animate(
                        withDuration: 0.65,
                        delay: 0.0,
                        options: UIViewAnimationOptions.curveEaseIn,
                        animations: {
                            self.distanceFallenLabel.alpha = 1.0
                        },
                        completion: {(finished: Bool) -> Void in
                            self.distanceFallen = 0
                            self.startTimeOfFreefall = 0
                            self.endTimeOfFreefall = 0
                        })
                })
        }
        
        launchModeRunning = false
    }
    
    // MARK: Calculations
    fileprivate func calcDistance (_ timeInSeconds: Float) -> Float{
        let acceleration: Float = 9.81
        let distanceFallen = (acceleration / 2) * (timeInSeconds * timeInSeconds)
        let roundedDistanceFallenInMeters = round((distanceFallen / 4) * 100) / 100
        return roundedDistanceFallenInMeters
    }
    
    fileprivate func compareTimes () -> CFTimeInterval {
        let timeInFreefall: CFTimeInterval = endTimeOfFreefall - startTimeOfFreefall
        return timeInFreefall
    }
}
