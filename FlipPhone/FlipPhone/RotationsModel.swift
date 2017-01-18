//
//  RotationsModel.swift
//  FlipPhone
//
//  Created by Alexander Mathers on 2016-02-08.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CoreMotion

final class RotationsModel: NSObject {
    
    fileprivate var rollStep1 : Bool = false
    fileprivate var rollStep2 : Bool = false
    fileprivate var rollStep3 : Bool = false
    fileprivate var yawStep1 : Bool = false
    fileprivate var yawStep2 : Bool = false
    fileprivate var yawStep3 : Bool = false
    fileprivate var pitchStep1 : Bool = false
    fileprivate var pitchStep2 : Bool = false
    fileprivate var pitchStep3 : Bool = false
    
    var rollCount = 0
    var yawCount = 0
    var pitchCount = 0
    
    func checkRoll (_ attitude: CMAttitude) {
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
        }
    }
    
    func checkSpin (_ attitude: CMAttitude) {
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
        }
    }
    
    func checkFlip (_ attitude: CMAttitude) {
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
        }
    }
}
