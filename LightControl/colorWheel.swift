//
//  colorWheel.swift
//  LightControl
//
//  Created by Oliver Adolfo Rodas on 8/5/19.
//  Copyright © 2019 Oliver Adolfo Rodas. All rights reserved.
//

import UIKit

class colorWheel: UIViewController {
    
    var redVal : CGFloat = 0
    var blueVal : CGFloat = 0.75
    var greenVal : CGFloat = 0.75
    var alphaVal : CGFloat = 1
    var modeIsOn : Bool = false
    var name : String = ""
    var isConnected : Bool = false
    var controller : ParticleDevice?
    var duration : Double = 1.5
    
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var colorViewer: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var connectedLabel: UILabel!
    @IBOutlet weak var redPeriod: UILabel!
    @IBOutlet weak var greenPeriod: UILabel!
    @IBOutlet weak var bluePeriod: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        brightnessSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        brightnessSlider.
        modeButton.layer.borderWidth = 2
        modeButton.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        redPeriod.textColor = UIColor.white
        redPeriod.alpha = 0
        redLabel.textColor = UIColor.white
        greenPeriod.textColor = UIColor.white
        greenPeriod.alpha = 0
        greenLabel.textColor = UIColor.white
        bluePeriod.textColor = UIColor.white
        bluePeriod.alpha = 0
        blueLabel.textColor = UIColor.white
        connectedLabel.layer.cornerRadius = connectedLabel.frame.width/2
        connectedLabel.layer.masksToBounds = true
        connectedLabel.layer.borderWidth = 2
        
        if (controller?.connected == true) {
            connectedLabel.backgroundColor = UIColor.green
        }
        else {
            connectedLabel.backgroundColor = UIColor.red
        }
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(check), userInfo: nil, repeats: true)
        
    }
    
    @objc func check() {
        if (isConnected != controller!.connected) {
            isConnected = controller!.connected
            if(isConnected) {
                name = "Connected"
                connectedLabel.backgroundColor = UIColor.green
            }
            else {
                name = "Not Connected"
                connectedLabel.backgroundColor = UIColor.red
            }
        }
        else {
            
            for i in stride(from: 0.0, to: (duration + 0.01), by: 0.01) {
                DispatchQueue.main.asyncAfter(deadline: .now() + (i)) {
                    self.connectedLabel.backgroundColor = self.connectedLabel.backgroundColor?.withAlphaComponent(CGFloat(0.25*cos(i * 2/self.duration * .pi) + 0.75))
                }
            }
        }
    }
    
    @IBAction func Mode(_ sender: Any) {
        modeIsOn = !modeIsOn
        if modeIsOn {
            modeButton.layer.backgroundColor =  UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.5).cgColor
            modeButton.setTitle("Automatic", for: .normal)
            redPeriod.alpha = 1
            greenPeriod.alpha = 1
            bluePeriod.alpha = 1
        }
        else {
            modeButton.layer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            modeButton.setTitle("Manual", for: .normal)
            redPeriod.alpha = 0
            greenPeriod.alpha = 0
            bluePeriod.alpha = 0
        }
        
        if isConnected {
            controller?.callFunction("setMode", withArguments: [String(modeIsOn)])
        }
    }
    
    @IBAction func loggedOut(_ sender: Any) {
        ParticleCloud.sharedInstance().logout()
    }
    
    @IBAction func redWheel(_ sender: UISlider) {
        redVal = CGFloat(sender.value)
        controller?.callFunction("setRed", withArguments: [String(Float(redVal))])
        updateView()
    }
    
    @IBAction func blueWheel(_ sender: UISlider) {
        blueVal = CGFloat(sender.value)
        controller?.callFunction("setBlue", withArguments: [String(Float(blueVal))])
        updateView()
    }
    
    @IBAction func greenWheel(_ sender: UISlider) {
        greenVal = CGFloat(sender.value)
        controller?.callFunction("setGreen", withArguments: [String(Float(greenVal))])
        updateView()
    }
    
    @IBAction func alphaWheel(_ sender: UISlider) {
        alphaVal = CGFloat(sender.value)
        controller?.callFunction("setBright", withArguments: [String(Float(alphaVal))])
        updateView()
    }
    
    func updateView() {
        colorViewer.backgroundColor = UIColor.init(red: redVal, green: greenVal, blue: blueVal, alpha: alphaVal)
        if(redVal >= 0.01 || redVal == 0) {
            redLabel.text = String(Int(Float(redVal) * 100))
        }
        else {
            redLabel.text = String((Float(redVal) * 1000).rounded() / 10)
        }
        
        if(greenVal >= 0.01 || greenVal == 0) {
            greenLabel.text = String(Int(Float(greenVal) * 100))
        }
        else {
            greenLabel.text = String((Float(greenVal) * 1000).rounded() / 10)
        }
        
        if(blueVal >= 0.01 || blueVal == 0) {
            blueLabel.text = String(Int(Float(blueVal) * 100))
        }
        else {
            blueLabel.text = String((Float(blueVal) * 1000).rounded() / 10)
        }
    }
}
