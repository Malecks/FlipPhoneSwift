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
    @IBOutlet var distanceFallenLabel: UILabel!
    
    var launchModeRunning: Bool = false
    var startTime : CFAbsoluteTime!
    var motion = CMMotionManager()
    var timeInFreefall: Float = 0
    var bestTimeInFreefall: Float = 0
    var distanceFallen: Float = 0

    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareCoreMotion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.presentingViewController
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        motion.stopDeviceMotionUpdates()
        motion.stopAccelerometerUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Preparation
    func prepareCoreMotion() {
        if motion.deviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)
            if motion.accelerometerAvailable {
                motion.accelerometerUpdateInterval = 0.01
                motion.startAccelerometerUpdates()
            }
        }
    }
    
    // MARK: Timer and updates
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateAcceleration"), userInfo: nil, repeats: true)
    }
    
    
    func updateAcceleration() {
        if motion.accelerometerActive == false || launchModeRunning == false {
            return
        }
        // TODO: Get absolute times, when freefall starts and when it ends.
        
        
        print("NORMAL\(motion.deviceMotion?.gravity.z)")
        // if freefall?
        if (motion.deviceMotion?.gravity.z) < 0.30 && (motion.deviceMotion?.gravity.z) > -0.30 {
            print("FREEFALL: \(motion.deviceMotion?.gravity.z)")
            timeInFreefall += 1
            if timeInFreefall > bestTimeInFreefall {
                bestTimeInFreefall = timeInFreefall
            }
            
        } else {
        
            timeInFreefall = 0
        }
    
        // time label
        let remainingTime = round((3.0 - (CFAbsoluteTimeGetCurrent() - startTime)) * 100) / 100
        if remainingTime > 0 {
            timeLabel.text = "\(remainingTime)"
            print(remainingTime)
        } else {
            timeLabel.text = "0.0"
        }
    }
    
    
    // MARK: Handlers
    @IBAction func flipModeButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startButton(sender: UIButton) {
        // start 3 second timer
        startTimer()
        launchModeRunning = true
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "stopLaunchMode", userInfo: nil, repeats: false)
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stopLaunchMode () {
        if launchModeRunning {
            print(timeInFreefall)
            distanceFallen = calcDistance(bestTimeInFreefall)
            distanceFallenLabel.text = "\(distanceFallen)"
            bestTimeInFreefall = 0
        }
        launchModeRunning = false
    }
    
    
    func calcDistance (timeInMilliseconds: Float) -> Float{
        let timeInSeconds: Float = timeInMilliseconds / 1000
        print("TIME IN SECONDS: \(timeInSeconds)")
        let acceleration: Float = 9.81
        let distanceFallen = (acceleration / 2) * (timeInSeconds * timeInSeconds)
        return distanceFallen
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
