//
//  LocalNotificationManager.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 23.01.2023.
//
import Foundation
import UserNotifications

protocol NotificationProtocol {
    func sendNotification(title: String, message: String)
}

final class LocalNotificationManager: NotificationProtocol {
    static let shared = LocalNotificationManager()
    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func sendNotification(title: String, message: String) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = title
        notificationContent.subtitle = message
        notificationContent.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        self.notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
}
