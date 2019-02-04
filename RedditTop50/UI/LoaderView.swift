//
//  LoaderView.swift
//  RedditTop50
//
//  Created by Robert Brennan on 2/3/19.
//  Copyright © 2019 Creatility. All rights reserved.
//
///https://github.com/johnlui/SwiftNotice/blob/swift4/SwiftNotice.swift

import Foundation
import UIKit

//MARK: Global Functions Extenstion
extension UIResponder {

    @discardableResult
    func pleaseWait() -> UIWindow{
        return SwiftNotice.wait()
    }

    func clearAllNotice() {
        SwiftNotice.clear()
    }
}

class SwiftNotice: NSObject {
    
    static var windows = Array<UIWindow?>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView?
    static var timer: DispatchSource!
    static var timerTimes = 0
    
    /* just for iOS 8
     */
    static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }

    static func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }

    @discardableResult
    static func wait(_ imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Int = 0) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 65
        mainView.backgroundColor = UIColor(red:67/255, green:170/255, blue:232/255, alpha: 1.0)
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = UIView.ContentMode.scaleAspectFit
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as? DispatchSource
                timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeInterval))
                timer.setEventHandler(handler: { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes += 1
                })
                timer.resume()
            }
        } else {
            
            let iv = UIImageView(frame: frame)
            iv.frame = CGRect(x: 16, y: 16, width: 100, height: 90)
            iv.image = UIImage(named: "RedditIconWhite")
            iv.alpha = 1.0
            let animation = UIViewPropertyAnimator(duration: 1.3, curve: .easeInOut) {
                UIView.setAnimationRepeatCount(.infinity)
                iv.alpha = 0.2
            }
            animation.startAnimation()
            
            mainView.addSubview(iv)
        }
        
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return window
    }

    // just for iOS 8
    static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.rawValue >= 3 {
            return CGPoint(x: rv!.center.y, y: rv!.center.x)
        } else {
            return rv!.center
        }
    }
}
