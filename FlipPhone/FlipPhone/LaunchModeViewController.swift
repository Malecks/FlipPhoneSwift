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
    var didStartThrow: Bool = false
    var startTimeOfFreefall: CFAbsoluteTime = 0.0
    var endTimeOfFreefall: CFAbsoluteTime = 0.0
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
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateGravity"), userInfo: nil, repeats: true)
        //        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateAcceleration"), userInfo: nil, repeats: true)
    }
    
    
    func updateGravity() {
        if motion.deviceMotionActive == false || launchModeRunning == false {
            return
        }
        // if freefall
        let gX = motion.accelerometerData?.acceleration.x
        let gY = motion.accelerometerData?.acceleration.y
        let gZ = motion.accelerometerData?.acceleration.z
        let totalGravity = sqrt((gX! * gX!) + (gY! * gY!) + (gZ! * gZ!))
//        print("GGG: \(totalGravity)")
        
        if totalGravity < 0.2 && totalGravity > -0.2 { // if gravity.z is around 0 (+ or - .15)
            
            // get time at start of freefall
            if didStartThrow == false {
                if startTimeOfFreefall == 0 {
                    startTimeOfFreefall = CFAbsoluteTimeGetCurrent()
                    print("START of freefall:\(startTimeOfFreefall)")
                    didStartThrow = true
                }
            }
//            print("FREEFALL VALUE: \(motion.deviceMotion?.gravity.z)")
        }
        
        // get end time when out of freefall
        if didStartThrow && totalGravity > 0.3 { // if gravity.z leaves freefall (resting is around -1)
            if endTimeOfFreefall == 0 {
                endTimeOfFreefall = CFAbsoluteTimeGetCurrent()
                print("END of freefall: \(endTimeOfFreefall)")
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
        if remainingTime > 0 {
            timeLabel.text = "\(remainingTime)"
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
            distanceFallenLabel.text = "\(distanceFallen)m"
            distanceFallen = 0
            startTimeOfFreefall = 0
            endTimeOfFreefall = 0
        }
        launchModeRunning = false
    }
    
    // MARK: Calculations
    func calcDistance (timeInSeconds: Float) -> Float{
        let acceleration: Float = 9.81
        let distanceFallen = (acceleration / 2) * (timeInSeconds * timeInSeconds)
        let roundedDistanceFallenInMeters = round((distanceFallen / 4) * 100) / 100
        return roundedDistanceFallenInMeters
    }
    
    func compareTimes () -> CFTimeInterval {
        let timeInFreefall: CFTimeInterval = endTimeOfFreefall - startTimeOfFreefall
        print("Time In Freefall: \(timeInFreefall)")
        return timeInFreefall
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
