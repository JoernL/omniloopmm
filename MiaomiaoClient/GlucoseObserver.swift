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
        
    public func observeGlucose() {
        
        if (glucoseValue > 90 && glucoseValue < 200) {
            return
            
        }
        
        if glucoseValue < 90 {
            
            let content = UNMutableNotificationContent()
            content.title = "LOW GLUCOSE!"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
            UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle
        })
            return
        }
        
        if glucoseValue > 200 {
        
           
            let content = UNMutableNotificationContent()
            content.title = "LOW GLUCOSE!"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle
            })
            
            
    }
        return
    
    }
    
}

