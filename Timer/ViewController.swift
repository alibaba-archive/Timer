//
//  ViewController.swift
//  Timer
//
//  Created by Qi Junyuan on 2/22/15.
//  Copyright (c) 2015 Qi Junyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var timeLabel: UILabel!
    var translation: CGFloat!
    var lastTimer: Int! = 0
    var leftTime: Int! = 0
    var touchView: UIView!
    var refreshTimer: NSTimer!
    var mainTimer: NSTimer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Polish Time Font
        var timeFeatureSettings = [
                [
                    UIFontFeatureTypeIdentifierKey:kNumberSpacingType,
                    UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector],
                [
                    UIFontFeatureTypeIdentifierKey: kCharacterAlternativesType,
                    UIFontFeatureSelectorIdentifierKey:1]]
        var font:UIFont = UIFont(name: "HelveticaNeue-Thin", size: 72.0)!
        var originalDescriptor = font.fontDescriptor()
        var timeDescriptor = originalDescriptor.fontDescriptorByAddingAttributes([UIFontDescriptorFeatureSettingsAttribute: timeFeatureSettings])
        var timeFont = UIFont(descriptor: timeDescriptor, size: 72.0)
        timeLabel.font = timeFont
        
        // Set Up Touch Layer
        touchView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(touchView)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delegate = self
        touchView.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePan(panGestureRecognizer: UIPanGestureRecognizer) {
        var gestureTranslation = panGestureRecognizer.translationInView(self.view)
        var gestureLocation = panGestureRecognizer.locationInView(self.view)
        translation = self.view.frame.height * tanh(gestureTranslation.y / 500)
        
        if (panGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            touchView.removeGestureRecognizer(panGestureRecognizer)
            self.setTimer(self.lastTimer)
        } else {
            var time = Int((translation / self.view.frame.height) * 100)
            if (time >= 0 && abs(time - lastTimer) >= 1) {
                lastTimer = time
                var minuteString: String
                if (lastTimer < 10) {
                    minuteString = "0\(lastTimer)"
                } else {
                    minuteString = "\(lastTimer)"
                }
                
                timeLabel.text = "\(minuteString):00"
            }
        }
    }
    
    func setTimer(interval: Int) {
        leftTime = interval * 60
        
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "refreshTimeLabel:",
            userInfo: nil,
            repeats: true)
        
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(leftTime),
            target: self,
            selector: "stopTimer:",
            userInfo: nil,
            repeats: false)
    }
    
    func refreshTimeLabel(timer: NSTimer) {
        leftTime = leftTime - 1
        
        var minuteString: String
        var secondString: String
        var minute = Int(floor(Double(leftTime) / 60))
        var second = leftTime % 60
        
        if (minute < 10) {
            minuteString = "0\(minute)"
        } else {
            minuteString = "\(minute)"
        }
        
        if (second < 10) {
            secondString = "0\(second)"
        } else {
            secondString = "\(second)"
        }
        
        timeLabel.text = minuteString + ":" + secondString
    }
    
    func stopTimer(timer: NSTimer) {
        refreshTimer.invalidate()
        touchView.addGestureRecognizer(panGestureRecognizer)
    }
}

