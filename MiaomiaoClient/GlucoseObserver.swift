//
//  GlucoseObserver.swift
//  MiaomiaoClient
//
//  Created by Jörn on 05.05.19.
//  Copyright © 2019 Mark Wilson. All rights reserved.
//

import Foundation
import AudioToolbox
import UserNotifications


public class GlucoseObserver {
    
    let glucoseValue = defaults.float(forKey: "glucoseValue")
    
    
    public func alarmLow()  {
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        content.title = "LOW GLUCOSE!"
        content.sound = UNNotificationSound.defaultCritical
        content.badge = 0
        
    }
    
    public func alarmHigh()  {
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        content.title = "HIGH GLUCOSE!"
        content.sound = UNNotificationSound.defaultCritical
        content.badge = 0
    }
    public func observe() {
        
        
        if glucoseValue < 90 {
           
            alarmLow()
            
            for _ in 1...3 {
                
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1000) {}
                
        }
            
            
    }
        if glucoseValue > 200 {
            
            alarmHigh()
            
            for _ in 1...3 {
                
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1000) {}
            }
        }
    }
}

