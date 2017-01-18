//
//  LaunchPatternView.swift
//  CircleBackground
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@IBDesignable

final class LaunchPatternView: UIView {
    static let size: CGFloat = 70
    fileprivate let backgroundRed: UIColor = UIColor(red: 229/255.0, green: 14/255.0, blue: 40/255.0, alpha: 1)
    fileprivate let redStrokeColour: UIColor = UIColor(red: 215/255.0, green: 14/255.0, blue: 40/255.0, alpha: 1)

    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(backgroundRed.cgColor)
        context.fill(bounds)
        
        let drawSize = CGSize(width: LaunchPatternView.size, height: LaunchPatternView.size)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        backgroundRed.setFill()
        drawingContext?.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let linePath = UIBezierPath()
        linePath.move(to: (CGPoint(x: LaunchPatternView.size, y: 0)))
        linePath.addCurve(
            to: (CGPoint(x: 0, y: LaunchPatternView.size)),
            controlPoint1: (CGPoint(x: LaunchPatternView.size, y: LaunchPatternView.size)),
            controlPoint2: (CGPoint(x: (LaunchPatternView.size / 2), y: (LaunchPatternView.size / 2)))
        )
        
        linePath.move(to: (CGPoint(x: LaunchPatternView.size, y: 0)))
        linePath.addCurve(
            to: (CGPoint(x: 0, y: LaunchPatternView.size)),
            controlPoint1: (CGPoint(x: (LaunchPatternView.size / 2), y: (LaunchPatternView.size / 2))),
            controlPoint2: (CGPoint(x: 0, y: 0))
        )
        redStrokeColour.setStroke()
        linePath.stroke()
        
        let circlePath2 = UIBezierPath(ovalIn: CGRect(
            x: LaunchPatternView.size / 2,
            y: LaunchPatternView.size / 2,
            width: LaunchPatternView.size,
            height: LaunchPatternView.size
        ))
        redStrokeColour.setStroke()
        circlePath2.stroke()
        
        let circlePath3 = UIBezierPath(ovalIn: CGRect(
            x: -LaunchPatternView.size / 2,
            y: LaunchPatternView.size / 2,
            width: LaunchPatternView.size,
            height: LaunchPatternView.size
        ))
        redStrokeColour.setStroke()
        circlePath3.stroke()
        
        let circlePath4 = UIBezierPath(ovalIn: CGRect(
            x: LaunchPatternView.size / 2,
            y: -LaunchPatternView.size / 2,
            width: LaunchPatternView.size,
            height: LaunchPatternView.size
        ))
        redStrokeColour.setStroke()
        circlePath4.stroke()
        
        let circlePath5 = UIBezierPath(ovalIn: CGRect(
            x: -LaunchPatternView.size / 2,
            y: -LaunchPatternView.size / 2,
            width: LaunchPatternView.size,
            height: LaunchPatternView.size
        ))
        redStrokeColour.setStroke()
        circlePath5.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image!).setFill()
        context.fill(rect)
    }
}
