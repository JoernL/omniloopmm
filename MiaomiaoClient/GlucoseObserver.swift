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

var firstRun : Bool = true

public class GlucoseObserver {
    
   
    public func observeGlucose() {
        
        let glucoseValue = defaults.float(forKey: "glucoseValue")
        if  firstRun == true {
            defaults.set(false, forKey: "snoozeTimer")
            firstRun = false
        }

        if defaults.bool(forKey: "snoozeTimer") == true {
            return
            }
        
        if (glucoseValue > 90 && glucoseValue < 200)  {
                return
            
        }
        
        else if glucoseValue < 90 {
        
            AudioServicesPlaySystemSound(1520)
            let content = UNMutableNotificationContent()
            let notificationCenter = UNUserNotificationCenter.current()
            content.title = "LOW GLUCOSE"
            content.body = "Push for snooze option"
            content.categoryIdentifier = "alarm.category"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
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
        
            AudioServicesPlaySystemSound(1521)
            let content = UNMutableNotificationContent()
            let notificationCenter = UNUserNotificationCenter.current()
            content.title = "HIGH GLUCOSE"
            content.body = "Push for snooze option"
            content.categoryIdentifier = "alarm.category"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
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

