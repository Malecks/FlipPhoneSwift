//
//  PatternView.swift
//  CircleBackground
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@IBDesignable

class PatternView: UIView {
    let patternSize: CGFloat = 70
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        let backgroundBlue: UIColor = UIColor(red: 22/255.0, green: 115/255.0, blue: 225/255.0, alpha: 1)
        let blueStrokeColour: UIColor = UIColor(red: 15/255.0, green: 100/255.0, blue: 245/255.0, alpha: 1)
        
        CGContextSetFillColorWithColor(context, backgroundBlue.CGColor)
        CGContextFillRect(context, bounds)
        
        ///////
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        backgroundBlue.setFill()
        CGContextFillRect(drawingContext,
            CGRectMake(0, 0, drawSize.width, drawSize.height))
        
        // circle
        let circlePath = UIBezierPath(ovalInRect: CGRectMake( 0, 0, patternSize, patternSize))
        blueStrokeColour.setStroke()
        circlePath.stroke()
        
        let circlePath2 = UIBezierPath(ovalInRect: CGRectMake( patternSize/2, patternSize/2, patternSize, patternSize))
        blueStrokeColour.setStroke()
        circlePath2.stroke()
        
        let circlePath3 = UIBezierPath(ovalInRect: CGRectMake( -patternSize/2, patternSize/2, patternSize, patternSize))
        blueStrokeColour.setStroke()
        circlePath3.stroke()
        
        let circlePath4 = UIBezierPath(ovalInRect: CGRectMake( patternSize/2, -patternSize/2, patternSize, patternSize))
        blueStrokeColour.setStroke()
        circlePath4.stroke()
        
        let circlePath5 = UIBezierPath(ovalInRect: CGRectMake( -patternSize/2, -patternSize/2, patternSize, patternSize))
        blueStrokeColour.setStroke()
        circlePath5.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        CGContextFillRect(context, rect)

//        let gradient:CAGradientLayer = CAGradientLayer()
//        gradient.frame.size = self.frame.size
//        gradient.colors = [backgroundBlue.CGColor, UIColor.whiteColor().colorWithAlphaComponent(0).CGColor] //Or any colors
//        self.layer.addSublayer(gradient)
    }


}
