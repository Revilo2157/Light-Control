//
//  ViewController.swift
//  LightControl
//
//  Created by Oliver Adolfo Rodas on 8/5/19.
//  Copyright © 2019 Oliver Adolfo Rodas. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController, ParticleSetupMainControllerDelegate {
    
    var controllers : [ParticleDevice] = []
    let monitor = NWPathMonitor()

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 2
        
    }
    
    func particleSetupViewController(_ controller: ParticleSetupMainController!, didNotSucceeedWithDeviceID deviceID: String!) {
        print("Oh no setup failed")
        
    }
    
    func particleSetupViewController(_ controller: ParticleSetupMainController!, didFinishWith result: ParticleSetupMainControllerResult, device: ParticleDevice!) {
        
        switch result
        {
        case .success:
            print("Setup completed successfully")
        case .failureConfigure:
            fallthrough
        case .failureCannotDisconnectFromDevice:
            fallthrough
        case .failureLostConnectionToDevice:
            fallthrough
        case .failureClaiming:
            print("Setup failed")
        case .userCancel :
            print("User cancelled setup")
        case .loggedIn :
            print("User is logged in")
        default:
            print("Uknown setup error")
            
        }
        
        if device != nil
        {
            device.getVariable("test", completion: { (value, err) -> Void in
                
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is colorWheel {
            if let vc = segue.destination as? colorWheel {
                ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
                    if (!(devices?.isEmpty ?? true)) {
                        self.controllers = devices!
                    }
                    if (!self.controllers.isEmpty) {
                        for device in devices! {
                            if device.name == "Light_Control" {
                                vc.controller = device
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ParticleCloud.sharedInstance().isAuthenticated {
            self.performSegue(withIdentifier: "colorWheelView", sender: self)
        }
    }
    
    
    @IBAction func begin(_ sender: Any) {
        
        if let setupController = ParticleSetupMainController(authenticationOnly: true)
        {
            setupController.delegate = self //as! UIViewController & ParticleSetupMainControllerDelegate
            self.present(setupController, animated: true, completion: nil)
        }
        
    }

}

