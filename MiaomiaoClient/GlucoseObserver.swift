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


var timer: Timer?

public class GlucoseObserver {
    
    enum Action: String {
        case retryBolus
    }
    
    @objc public func update() {
        
            var timeLeft = defaults.integer(forKey: "snoozeTimer")
            timeLeft-=1
            defaults.set(timeLeft, forKey: "snoozeTimer")
            if timeLeft <= 0 {
               timer?.invalidate()
               timer = nil
            }
        
            NSLog("joernl:: low timer up")
        
    }
 
  
    
    
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
                                                    title:"Snooze",options: UNNotificationActionOptions())
            let category = UNNotificationCategory(identifier: "snoozeCategory",
                                                  actions: [snoozeAction],
                                                  intentIdentifiers: [], options: [])
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.setNotificationCategories([category])
            notificationCenter.add(request, withCompletionHandler: nil)
            
            func userNotificationCenter(_ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler:
            @escaping () -> Void) {
                
            switch response.actionIdentifier {
                case "snooze":
                    defaults.set(1200, forKey: "snoozeTimer")
                    
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    
                    
                    break
                default:
                    
                        completionHandler()
                    break
                
                
                
                
            
            }
        }
        
    }
        
        else if glucoseValue > 200 {
        
            
            
            let content = UNMutableNotificationContent()
            content.title = "HIGH GLUCOSE"
            content.body = "Push for snooze option"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 0
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "snoozeNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle
                                                    
            })
            
            
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.requestAuthorization(options: [.badge, .sound, .alert], completionHandler:{ _, _ in })
            
            
            var notificationCategories: Set<UNNotificationCategory> {
                var categories = [UNNotificationCategory]()
                
                let snoozeAction = UNNotificationAction(identifier: Action.retryBolus.rawValue,
                                                    title:"Snooze", options: [])
            
            
                categories.append(UNNotificationCategory(identifier: LoopNotificationCategory.bolusFailure.rawValue, actions: [snoozeAction], intentIdentifiers: [], options: []))
                
                return Set(categories)
            }
            
            
            notificationCenter.setNotificationCategories(notificationCategories)
            notificationCenter.add(request, withCompletionHandler: nil)
           
            
            func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler:
                @escaping () -> Void) {
                
                
                if response.actionIdentifier == Action.retryBolus.rawValue {
                    
                    print("joernl:: high timer1 up")
                    
                    NSLog("joernl:: high timer1 up")
                    defaults.set(5400, forKey: "snoozeTimer")
                    
                   DispatchQueue.global(qos: .background).async {
                        var timerCount = 5400
                        while (timerCount > 0) {
                            timerCount-=1
                            defaults.set(timerCount, forKey: "snoozeTimer")
                            sleep(1)
                            
                            NSLog("joernl:: high2 timer up")
                            }
                        }
                    
                            completionHandler()
                   
               
                }
            
             }
          }
       }
   }
}



