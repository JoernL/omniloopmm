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
    
    let glucoseValue: Double = defaults.object(forKey: "glucoseValue") as! Double
    
    public func observe() {
        
        if glucoseValue < 90 {
           
            for _ in 1...3 { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
        }
            
            
    }
        if glucoseValue > 200 {
            
            for _ in 1...3 {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
            }
        }
    }
}

