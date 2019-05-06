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
    public var snoozeTimer = 0
    
    public func observeGlucose() {
        
        if (glucoseValue > 90 && glucoseValue < 200 || snoozeTimer > 0) {
            return
            
        }
        
        if glucoseValue < 90 {
            
            let content = UNMutableNotificationContent()
            content.title = "LOW GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "snoozeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
            
            let snoozeAction = UNNotificationAction(identifier:"snooze",
                                                    title:"Snooze",options:[])
            
            let category = UNNotificationCategory(identifier: "snoozeCategory",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [], options: [])
            
            content.categoryIdentifier = "snoozeCategory"
            
            UNUserNotificationCenter.current().setNotificationCategories(
                [category])
        
            UNUserNotificationCenter.current().add(request,
            withCompletionHandler: { (error) in
                    // Handle
                
                })
            func userNotificationCenter(_ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler:
            @escaping () -> Void) {
                                                    
                
            switch response.actionIdentifier {
                case "snooze":
                    snoozeTimer = 1200
                    var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                    func update() {
                        
                        if snoozeTimer > 0 {
                            snoozeTimer-=1
                        }
                        
                    }
                
                
                default:
                break
                }
                    completionHandler()
                
            
        }
    }
        
        if glucoseValue > 200 {
        
           
            let content = UNMutableNotificationContent()
            content.title = "HIGH GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "snoozeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            let snoozeAction = UNNotificationAction(identifier:"snooze",
                                                    title:"Snooze",options:[])
            
            let category = UNNotificationCategory(identifier: "snoozeCategory",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [], options: [])
            
            content.categoryIdentifier = "snoozeCategory"
            
            UNUserNotificationCenter.current().setNotificationCategories(
                [category])
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle
                                                    
            })
            func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler:
                @escaping () -> Void) {
                
                
                switch response.actionIdentifier {
                case "snooze":
                    snoozeTimer = 5400
                    var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                    func update() {
                        
                        if snoozeTimer > 0 {
                            snoozeTimer-=1
                        }
                        
                    }
                    
                default:
                    break
                }
                    completionHandler()
               
              }
         
         }
     }
  }



