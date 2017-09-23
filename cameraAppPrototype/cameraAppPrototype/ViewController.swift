//
//  ViewController.swift
//  MyCameraTest01
//
//  Created by ChoSeung Yun on 2017. 4. 28..
//  Copyright © 2017년 ChoSeung Yun. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class ViewController: UIViewController {
    fileprivate var visage : Visage?
    
    fileprivate let notificationCenter : NotificationCenter = NotificationCenter.default
    
    let emojiLabel : UILabel = UILabel(frame: UIScreen.main.bounds)
    let faceBox : UIView = UIView()
    let leftEyeLabel : UILabel = UILabel()
    let rightEyeLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        visage = Visage(cameraPosition: Visage.CameraDevice.faceTimeCamera, optimizeFor: Visage.DetectorAccuracy.batterySaving)
        
        //If you enable "onlyFireNotificationOnStatusChange" you won't get a continuous "stream" of notifications, but only one notification once the status changes.
        visage!.onlyFireNotificatonOnStatusChange = false
        
        
        //You need to call "beginFaceDetection" to start the detection, but also if you want to use the cameraView.
        visage!.beginFaceDetection()
        
        //This is a very simple cameraView you can use to preview the image that is seen by the camera.
        let cameraView = visage!.visageCameraView
        self.view.addSubview(cameraView)
        
        emojiLabel.text = "😨"
        emojiLabel.font = UIFont.systemFont(ofSize: 50)
        emojiLabel.textAlignment = .center
        //self.view.addSubview(emojiLabel)
        
        faceBox.layer.borderWidth = 3
        faceBox.layer.borderColor = UIColor.red.cgColor
        faceBox.backgroundColor = UIColor.clear
        self.view.addSubview(faceBox)
        
        leftEyeLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        leftEyeLabel.text = "👁"
        leftEyeLabel.font = UIFont.systemFont(ofSize: 40)
        leftEyeLabel.textAlignment = .center
        self.view.addSubview(leftEyeLabel)
        
        rightEyeLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        rightEyeLabel.text = "👁"
        rightEyeLabel.font = UIFont.systemFont(ofSize: 40)
        rightEyeLabel.textAlignment = .center
        self.view.addSubview(rightEyeLabel)
        
        
        //Subscribing to the "visageFaceDetectedNotification" (for a list of all available notifications check out the "ReadMe" or switch to "Visage.swift") and reacting to it with a completionHandler. You can also use the other .addObserver-Methods to react to notifications.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 1
                self.faceBox.alpha = 1
                self.leftEyeLabel.alpha = 0.6
                self.rightEyeLabel.alpha = 0.6
            })
            
            if (self.visage!.faceDetected == false) {
                self.emojiLabel.text = "😨"
            } else {
                self.faceBox.frame = self.visage!.faceBounds!
                
                self.leftEyeLabel.frame.origin.x = self.visage!.leftEyePosition!.x - 30
                self.leftEyeLabel.frame.origin.y = self.visage!.leftEyePosition!.y - 30
                self.rightEyeLabel.frame.origin.x = self.visage!.rightEyePosition!.x - 30
                self.rightEyeLabel.frame.origin.y = self.visage!.rightEyePosition!.y - 30
                
                if (self.visage!.leftEyeClosed == true) {
                    self.leftEyeLabel.text = "😡"
                } else {
                    self.leftEyeLabel.text = "👁"
                }
        
                if (self.visage!.rightEyeClosed == true) {
                    self.rightEyeLabel.text = "😡"
                } else {
                    self.rightEyeLabel.text = "👁"
                }

                if (self.visage!.isWinking == true) {
    //                print(String(NSDate().timeIntervalSinceReferenceDate) + "Wink")
                    self.emojiLabel.text = "😉"
                } else {
    //                print(String(NSDate().timeIntervalSinceReferenceDate) + "Open")
                    self.emojiLabel.text = "😐"
                }
            }
        })
        
        //The same thing for the opposite, when no face is detected things are reset.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageNoFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 0.25
                self.faceBox.alpha = 0.25
                self.leftEyeLabel.alpha = 0.1
                self.rightEyeLabel.alpha = 0.1
            })
        })
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

