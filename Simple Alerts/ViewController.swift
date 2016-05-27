//
//  ViewController.swift
//  Simple Alerts
//
//  Created by Sylvan .D. Ash on 11/6/15.
//  Copyright © 2015 Daitensai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var replayButton: UIBarButtonItem!
    
    let timerLabel      = UILabel()
    let outlineCircle   = CAShapeLayer()
    let animationCircle = CAShapeLayer()
    let drawAnimation   = CABasicAnimation(keyPath: "strokeEnd")
    var timer           = NSTimer()
    var counter         = 60
    
    // By changing the fraction, we can change how much of the circle is initially filled
    let fractionOfCircle = 4.0 / 4.0
    
    
    // MARK: - Standard methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupClock()
        startTimer()
        startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - IBActions
    
    @IBAction func restartTimer(sender: AnyObject) {
        startTimer()
        startAnimation()
    }

    
    // MARK: - Helper functions
    
    /**
     * Setup the view of the timer including an animated circle that counts down the clock
     */
    func setupClock() {
        let radius: CGFloat = 100.0
        
        // Have the center of the circle as the center of the view
        let center  = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))
        let twoPI   = 2.0 * Double(M_PI)
        
        let startAngle  = Double(fractionOfCircle) / Double(twoPI) - Double(M_PI_2)
        let endAngle    = 0.0 - Double(M_PI_2)
        let clockwise: Bool = true
        
        let labelFontSize = CGRectGetWidth(self.view.frame) / 4.0
        

        //
        // Configure the timer label
        timerLabel.frame     = CGRectMake(0, 0, 200, labelFontSize)
        timerLabel.center    = center
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.font      = UIFont(name: "ArialMT", size: labelFontSize)
        timerLabel.textColor = UIColor(red: 92, green: 125, blue: 160)
        timerLabel.text      = String(counter)
        
        //
        // Configure the animation circle
        animationCircle.path        = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        animationCircle.fillColor   = UIColor.clearColor().CGColor
        animationCircle.strokeColor = UIColor(red: 197, green: 116, blue: 0).CGColor
        animationCircle.lineWidth   = 10.0
        
        // When the animation ends, leave it at 0% stroke filled
        animationCircle.strokeEnd   = 0
        
        
        //
        // Configure the outline circle
        outlineCircle.path          = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true).CGPath
        outlineCircle.fillColor     = UIColor.clearColor().CGColor
        outlineCircle.strokeColor   = UIColor(red: 28, green: 27, blue: 27).CGColor
        outlineCircle.lineWidth     = 10.0
        
        
        //
        // Add the label and circles to the view with the animation circle on top of the outline circle
        self.view.layer.addSublayer(outlineCircle)
        self.view.layer.addSublayer(animationCircle)
        self.view.addSubview(timerLabel)
    }
    
    /**
     * Start the animation of the circle counting down the time
     */
    func startAnimation() {
        drawAnimation.repeatCount = 1.0
        
        // Animate from the full stroke being drawn to none of the stroke being drawn
        drawAnimation.fromValue = NSNumber(double: fractionOfCircle)
        drawAnimation.toValue   = NSNumber(float: 0.0)
        
        drawAnimation.duration  = 60.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        drawAnimation.delegate  = self
        
        //
        // Remove previous animations from the animation circle
        animationCircle.removeAllAnimations()
        
        //
        // Add the animation to the animation circle
        animationCircle.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
    }
    
    func startTimer() {
        counter         = 60
        timerLabel.text = String(counter)
        timer           = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        timerLabel.text = String(--counter)
    }
    
    
    // MARK: - Overrides
    
    override func animationDidStart(anim: CAAnimation) {
        // Disable replay button during animation
        replayButton.enabled = false
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        // Enable replay button afer animation
        replayButton.enabled = true
        timer.invalidate()
        
        //
        // Configure the alert view
        let alertController = UIAlertController(title: "Please update your license", message: nil, preferredStyle: .Alert)
        
        // Configure the "license" and "cancel" actions
        let licenseAction   = UIAlertAction(title: "Enter License", style: .Default, handler: nil)
        let cancelAction    = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        // Add the actions to the alert view
        alertController.addAction(licenseAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}


// MARK: - UIColor Extension

extension UIColor {
    // Extend the UIColor class to allow use of normal RGB values e.g. RGB(234, 54, 87)
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue = CGFloat(Double(blue) / 255.0)
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
    }
}