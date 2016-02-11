//
//  LaunchPatternView.swift
//  CircleBackground
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@IBDesignable

class LaunchPatternView: UIView {
    let patternSize: CGFloat = 70
    let backgroundRed: UIColor = UIColor(red: 229/255.0, green: 14/255.0, blue: 40/255.0, alpha: 1)
    let redStrokeColour: UIColor = UIColor(red: 215/255.0, green: 14/255.0, blue: 40/255.0, alpha: 1)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, backgroundRed.CGColor)
        CGContextFillRect(context, bounds)
        
        ///////
        let drawSize = CGSize(width: patternSize, height: patternSize)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        backgroundRed.setFill()
        CGContextFillRect(drawingContext,
            CGRectMake(0, 0, drawSize.width, drawSize.height))
        
        // line
        let linePath = UIBezierPath()
        
        // 45 degree lines
//        linePath.moveToPoint((CGPoint(x: patternSize, y: 0)))
//        linePath.addLineToPoint((CGPoint(x: 0, y: patternSize)))
        
//        linePath.moveToPoint((CGPoint(x: 50, y: 0)))
//        linePath.addLineToPoint((CGPoint(x: 0, y: 50)))
//        
//        linePath.moveToPoint((CGPoint(x: 30, y: 0)))
//        linePath.addLineToPoint((CGPoint(x: 0, y: 30)))
//        
//        linePath.moveToPoint((CGPoint(x: 10, y: 0)))
//        linePath.addLineToPoint((CGPoint(x: 0, y: 10)))
//        
//        linePath.moveToPoint((CGPoint(x: 70, y: 20)))
//        linePath.addLineToPoint((CGPoint(x: 20, y: 70)))
//        
//        linePath.moveToPoint((CGPoint(x: 70, y: 40)))
//        linePath.addLineToPoint((CGPoint(x: 40, y: 70)))

        // curvy lines
        linePath.moveToPoint((CGPoint(x: patternSize, y: 0)))
        linePath.addCurveToPoint((CGPoint(x: 0, y: patternSize)), controlPoint1: (CGPoint(x: patternSize, y: patternSize)), controlPoint2: (CGPoint(x: (patternSize / 2), y: (patternSize / 2))))
        
        linePath.moveToPoint((CGPoint(x: patternSize, y: 0)))
        linePath.addCurveToPoint((CGPoint(x: 0, y: patternSize)), controlPoint1: (CGPoint(x: (patternSize / 2), y: (patternSize / 2))), controlPoint2: (CGPoint(x: 0, y: 0)))

        redStrokeColour.setStroke()
        linePath.stroke()
        
        
        let circlePath2 = UIBezierPath(ovalInRect: CGRectMake( 35, 35, patternSize, patternSize))
        redStrokeColour.setStroke()
        circlePath2.stroke()
        
        let circlePath3 = UIBezierPath(ovalInRect: CGRectMake( -35, 35, patternSize, patternSize))
        redStrokeColour.setStroke()
        circlePath3.stroke()
        
        let circlePath4 = UIBezierPath(ovalInRect: CGRectMake( 35, -35, patternSize, patternSize))
        redStrokeColour.setStroke()
        circlePath4.stroke()
        
        let circlePath5 = UIBezierPath(ovalInRect: CGRectMake( -35, -35, patternSize, patternSize))
        redStrokeColour.setStroke()
        circlePath5.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        CGContextFillRect(context, rect)
    }
    
    
}
