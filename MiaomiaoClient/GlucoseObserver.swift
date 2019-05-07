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
    
    
    @objc public func update() {
        
        if defaults.integer(forKey: "snoozeTimer") > 0 {
            var timer = defaults.integer(forKey: "snoozeTimer")
            timer-=1
            defaults.set(timer, forKey: "snoozeTimer")
        }
    }
    
    
    let glucoseValue = defaults.float(forKey: "glucoseValue")
    
    
    public func observeGlucose() {
        
        
        if defaults.object(forKey: "snoozeTimer") != nil {
        
            var timerCheckA = defaults.integer(forKey: "snoozeTimer")
                DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {  var timerCheckB = defaults.integer(forKey: "snoozeTimer")
            if timerCheckA > timerCheckB {
                return
            }
            else {
                defaults.set(0, forKey: "snoozeTimer")
            }
          }
        }
        else {
                defaults.set(0, forKey: "snoozeTimer")
        }
        
        if ( (glucoseValue > 90 && glucoseValue < 200) || defaults.integer(forKey: "snoozeTimer") > 0)  {
            return
            
        }
        
        else if glucoseValue < 90 {
            
            let content = UNMutableNotificationContent()
            content.title = "LOW GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            content.categoryIdentifier = "snoozeCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "snoozeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle
                                                    
            })
            
            
            let snoozeAction = UNNotificationAction(identifier:"snooze",
                                                    title:"Snooze",options: UNNotificationActionOptions(rawValue: 0))
            let category = UNNotificationCategory(identifier: "snoozeCategory",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [] ,hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
            //content.categoryIdentifier = "categorySnooze"
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.setNotificationCategories([category])
            
            
            func userNotificationCenter(_ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler:
            @escaping () -> Void) {
                                                    
                
            switch response.actionIdentifier {
                case "snooze":
                    defaults.set(1200, forKey: "snoozeTimer")
                    
                    weak var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                
                default:
                break
                }
                    completionHandler()
                
            
        }
        
    }
        
        else if glucoseValue > 200 {
        
            let content = UNMutableNotificationContent()
            content.title = "HIGH GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            content.categoryIdentifier = "snoozeCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "snoozeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle
                                                    
            })
            
            
            let snoozeAction = UNNotificationAction(identifier:"snooze",
                                                    title:"Snooze",options: UNNotificationActionOptions(rawValue: 0))
            let category = UNNotificationCategory(identifier: "snoozeCategory",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [] ,hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
            //content.categoryIdentifier = "categorySnooze"
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.setNotificationCategories([category])
            
            
            func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler:
                @escaping () -> Void) {
                
                
                switch response.actionIdentifier {
                case "snooze":
                    defaults.set(5400, forKey: "snoozeTimer")
                    
                    weak var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                default:
                    break
                }
                completionHandler()
                
               
              }
         
         }
     }
  }



