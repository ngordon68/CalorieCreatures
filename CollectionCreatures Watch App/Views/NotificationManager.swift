//
//  NotificationManager.swift
//  CollectionCreatures Watch App
//
//  Created by Nick Gordon on 10/11/23.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("ERROR: \(error)")
                
            } else {
                    print("success")
                }
            }
        }
    
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Egg is ready to hatch!"
        content.subtitle = "Tap to hatch"
        content.sound = .default
        content.badge = 1
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    }
    

