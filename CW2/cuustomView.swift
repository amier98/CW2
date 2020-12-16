//
//  cuustomView.swift
//  CW2
//
//  Created by amier ali on 24/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit

class cuustomView: UIView {
    var progresslayer = CAShapeLayer()
    var progressTrack = CAShapeLayer()
    var prog:Double = 0.0
    private var labelPercent = UILabel()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    var progresscolor = UIColor.white {
        didSet {
            progresslayer.strokeColor = progresscolor.cgColor
        }
    }
    var colorTrack = UIColor.white {
        didSet {
            progressTrack.strokeColor = colorTrack.cgColor
        }
    }
    //this was created through the help of a youtube video
    //https://www.youtube.com/watch?v=Qh1Sxict3io&t=702s
    func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/3
        //this creates the circle
        //i had to adjust the height and width accordingly
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/3, y: frame.size.height/1.2), radius: (frame.size.width - 1.5) / 3, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        //this is for the first layer
        progressTrack.path = circlePath.cgPath
        progressTrack.fillColor = UIColor.clear.cgColor
        progressTrack.strokeColor = colorTrack.cgColor
        //this is the width of the line
        progressTrack.lineWidth = 6
        progressTrack.strokeEnd = 1.0
        colorTrack = UIColor.white
        layer.addSublayer(progressTrack)
        //this is for the second layer
        progresslayer.path = circlePath.cgPath
        progresslayer.fillColor = UIColor.clear.cgColor
        progresslayer.strokeColor = progresscolor.cgColor
        progresslayer.lineWidth = 6
        progresslayer.strokeEnd = CGFloat(prog)
        //this is the progress color
        progresscolor = UIColor.green
        layer.addSublayer(progresslayer)
  
    }
    //this is the fucntion which animates the circular progress bar
    func setProgresswithAnimation(duration: TimeInterval, value: Float)
    {
        let animationProgress = CABasicAnimation(keyPath: "strokeEnd")
        animationProgress.duration = duration
        animationProgress.fromValue = 0
        animationProgress.toValue = value
        animationProgress.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progresslayer.strokeEnd = CGFloat(value)
        progresslayer.add(animationProgress, forKey: "animateProgress")
    }
    
}
