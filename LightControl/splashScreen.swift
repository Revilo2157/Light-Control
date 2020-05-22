//
//  splashScreen.swift
//  LightControl
//
//  Created by Oliver Adolfo Rodas on 8/7/19.
//  Copyright © 2019 Oliver Adolfo Rodas. All rights reserved.
//

import UIKit

class splashScreen: UIViewController {
    
    var controllers : [ParticleDevice] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            self.performSegue(withIdentifier: "colorWheelSeg", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "viewControllerSeg", sender: self)
        }
    }

}
