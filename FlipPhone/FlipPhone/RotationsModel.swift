//
//  RotationsModel.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-08.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

class RotationsModel: NSObject {
    
    var rollCount = 0
    var yawCount = 0
    var pitchCount = 0
    
    var rollStep1 : Bool
    var rollStep2 : Bool
    var rollStep3 : Bool
    var yawStep1 : Bool
    var yawStep2 : Bool
    var yawStep3 : Bool
    var pitchStep1 : Bool
    var pitchStep2 : Bool
    var pitchStep3 : Bool
    
    override init() {
        rollStep1 = false
        rollStep2 = false
        rollStep3 = false
        yawStep1 = false
        yawStep2 = false
        yawStep3 = false
        pitchStep1 = false
        pitchStep2 = false
        pitchStep3 = false
    }
    
    // calc rolls
    func didRoll (attitude: CMAttitude) -> Bool {
        
        if attitude.roll < 0 && attitude.roll > -1.5 {
            rollStep1 = true
        }
        if rollStep1 && attitude.roll < -1.5 && attitude.roll > -2.5 {
            rollStep2 = true
        }
        if self.rollStep2 && attitude.roll > 1.5 {
            self.rollStep3 = true;
        }
        if rollStep1 && rollStep2 && rollStep3 {
            rollCount += 1
            rollStep1 = false
            rollStep2 = false
            rollStep3 = false
            print("Roll Count: \(rollCount)")
            return true
        } else {
            return false
        }
    }
    
    // calc spins
    func didSpin (attitude: CMAttitude) -> Bool {
        
        if attitude.yaw < 0 && attitude.yaw > -1.5 {
            yawStep1 = true
        }
        if yawStep1 && attitude.yaw < -1.5 && attitude.yaw > -2.5 {
            yawStep2 = true
        }
        if self.yawStep2 && attitude.yaw > 1.5 {
            self.yawStep3 = true;
        }
        if yawStep1 && yawStep2 && yawStep3 {
            yawCount += 1
            yawStep1 = false
            yawStep2 = false
            yawStep3 = false
            print("Spin Count: \(yawCount)")
            return true
        } else {
            return false
        }
    }
    
    // calc flips
    func didFlip (attitude: CMAttitude) -> Bool {
        if attitude.pitch < 0 && attitude.pitch > -0.75 {
            pitchStep1 = true
        }
        if pitchStep1 && attitude.yaw < -0.75 && attitude.yaw > -1.25 {
            pitchStep2 = true
        }
        if self.pitchStep2 && attitude.yaw > 0.75 {
            self.pitchStep3 = true;
        }
        if pitchStep1 && pitchStep2 && pitchStep3 {
            pitchCount += 1
            pitchStep1 = false
            pitchStep2 = false
            pitchStep3 = false
            print("Flip Count: \(pitchCount)")
            return true
        } else {
            return false
        }
    }
}
