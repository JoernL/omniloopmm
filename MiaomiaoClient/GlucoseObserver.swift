//
//  GlucoseObserver.swift
//  MiaomiaoClient
//
//  Created by Jörn on 05.05.19.
//  Copyright © 2019 Mark Wilson. All rights reserved.
//

import Foundation
import AudioToolbox

public class GlucoseObserver {
    
    let glucoseValue = defaults.float(forKey: "glucoseValue")
    
    public func observe() {
        
        if glucoseValue < 90 {
           
            for _ in 1...3 { AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1000) {}
                
        }
            
            
    }
        if glucoseValue > 200 {
            
            for _ in 1...3 {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1000) {}
            }
        }
    }
}

