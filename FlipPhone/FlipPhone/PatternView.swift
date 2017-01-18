//
//  PatternView.swift
//  CircleBackground
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@IBDesignable

final class PatternView: UIView {
    static let size: CGFloat = 70

    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let backgroundBlue: UIColor = UIColor(red: 22/255.0, green: 115/255.0, blue: 225/255.0, alpha: 1)
        let blueStrokeColour: UIColor = UIColor(red: 15/255.0, green: 100/255.0, blue: 245/255.0, alpha: 1)
        
        context.setFillColor(backgroundBlue.cgColor)
        context.fill(bounds)
        
        let drawSize = CGSize(width: PatternView.size, height: PatternView.size)
        
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        backgroundBlue.setFill()
        drawingContext?.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let circlePath = UIBezierPath(ovalIn: CGRect(
            x: 0,
            y: 0,
            width: PatternView.size,
            height: PatternView.size
        ))
        blueStrokeColour.setStroke()
        circlePath.stroke()
        
        let circlePath2 = UIBezierPath(ovalIn: CGRect(
            x: PatternView.size/2,
            y: PatternView.size/2,
            width: PatternView.size,
            height: PatternView.size
        ))
        blueStrokeColour.setStroke()
        circlePath2.stroke()
        
        let circlePath3 = UIBezierPath(ovalIn: CGRect(
            x: -PatternView.size/2,
            y: PatternView.size/2,
            width: PatternView.size,
            height: PatternView.size
        ))
        blueStrokeColour.setStroke()
        circlePath3.stroke()
        
        let circlePath4 = UIBezierPath(ovalIn: CGRect(
            x: PatternView.size/2,
            y: -PatternView.size/2,
            width: PatternView.size,
            height: PatternView.size
        ))
        blueStrokeColour.setStroke()
        circlePath4.stroke()
        
        let circlePath5 = UIBezierPath(ovalIn: CGRect(
            x: -PatternView.size/2,
            y: -PatternView.size/2,
            width: PatternView.size,
            height: PatternView.size
        ))
        blueStrokeColour.setStroke()
        circlePath5.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image!).setFill()
        context.fill(rect)
    }
}
