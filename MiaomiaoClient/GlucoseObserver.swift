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
import LoopKit

public class GlucoseObserver {
    
   
    public func observeGlucose() {
        
        
        let glucoseValue = defaults.float(forKey: "glucoseValue")
        if defaults.object(forKey: "snoozeTimer") == nil {
            defaults.set(0, forKey: "snoozeTimer")
        }
        
            let timerCheckA = defaults.integer(forKey: "snoozeTimer")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              
            let timerCheckB = defaults.integer(forKey: "snoozeTimer")
            if timerCheckA > timerCheckB {
                return
            }
        
        if ( (glucoseValue > 90 && glucoseValue < 200) ||  defaults.integer(forKey: "snoozeTimer") > 0)  {
                return
            
        }
        
        else if glucoseValue < 90 {
            
            let content = UNMutableNotificationContent()
            let notificationCenter = UNUserNotificationCenter.current()
            content.title = "LOW GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            content.categoryIdentifier = "alarm.category"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "alarm"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
            
            notificationCenter.add(request,
                                                   withCompletionHandler: { (error) in
                                                    
            })
            
            let snoozeAction = UNNotificationAction(identifier:"snooze20",
                                                    title:"Snooze 20min",options: UNNotificationActionOptions())
            let category = UNNotificationCategory(identifier: "alarm.category",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [], options: [])
            
            notificationCenter.setNotificationCategories([category])
            notificationCenter.add(request, withCompletionHandler: nil)
            
    }
        
        else if glucoseValue > 200 {
           
            let content = UNMutableNotificationContent()
            let notificationCenter = UNUserNotificationCenter.current()
            content.title = "HIGH GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            content.categoryIdentifier = "alarm.category"
           
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "alarm"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            notificationCenter.add(request,
                                                   withCompletionHandler: { (error) in
                                                    
            })
                       
            let snoozeAction = UNNotificationAction(identifier: "snooze90",
                                                        title:"Snooze 90min",options: UNNotificationActionOptions())
            
            let category = UNNotificationCategory(identifier: "alarm.category",                                                actions: [snoozeAction],
                                                  intentIdentifiers: [], options: [])
            
            notificationCenter.setNotificationCategories([category])
            notificationCenter.add(request, withCompletionHandler: nil)
            
           }
           
        }
    }
}
