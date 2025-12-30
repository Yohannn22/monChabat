//
//  NotificationManager.swift
//  monChabat
//
//  Gestion des notifications pour les rappels de Shabbat
//

import Foundation
import UserNotifications
import Combine

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    
    // Configuration des rappels
    @Published var reminder1HourEnabled = true
    @Published var reminder15MinEnabled = true
    @Published var candleLightingReminderEnabled = true
    @Published var hallaTimerEnabled = true
    
    init() {
        Task { @MainActor in
            await checkAuthorization()
        }
    }
    
    @MainActor
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted
        } catch {
            print("Notification authorization error: \(error)")
        }
    }
    
    @MainActor
    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - Shabbat Reminders
    func scheduleCandleLightingReminders(for candleLightingTime: Date) async {
        guard isAuthorized else {
            await requestAuthorization()
            return
        }
        
        // Remove old candle lighting notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["candles-1h", "candles-15min", "candles-now"]
        )
        
        // 1 hour before
        if reminder1HourEnabled {
            let oneHourBefore = candleLightingTime.addingTimeInterval(-3600)
            if oneHourBefore > Date() {
                await scheduleNotification(
                    id: "candles-1h",
                    title: "🕯️ Chabat dans 1 heure",
                    body: "Pensez à finaliser vos préparatifs !",
                    date: oneHourBefore
                )
            }
        }
        
        // 15 minutes before
        if reminder15MinEnabled {
            let fifteenMinBefore = candleLightingTime.addingTimeInterval(-900)
            if fifteenMinBefore > Date() {
                await scheduleNotification(
                    id: "candles-15min",
                    title: "🕯️ Allumage dans 15 minutes",
                    body: "Il est temps d'allumer les bougies !",
                    date: fifteenMinBefore,
                    sound: .default
                )
            }
        }
        
        // At candle lighting time
        if candleLightingReminderEnabled {
            if candleLightingTime > Date() {
                await scheduleNotification(
                    id: "candles-now",
                    title: "🕯️ Chabat Chalom !",
                    body: "Allumage des bougies maintenant",
                    date: candleLightingTime,
                    sound: .default
                )
            }
        }
    }
    
    // MARK: - Halla Timer
    func scheduleHallaReminder(for targetTime: Date, phase: String) async {
        guard isAuthorized else { return }
        
        await scheduleNotification(
            id: "halla-\(phase)",
            title: "🍞 Timer Halla",
            body: "C'est le moment pour: \(phase)",
            date: targetTime,
            sound: .default
        )
    }
    
    // MARK: - Checklist Reminders
    func scheduleChecklistReminder(hoursBeforeChabat: Int, candleLightingTime: Date) async {
        guard isAuthorized else { return }
        
        let reminderTime = candleLightingTime.addingTimeInterval(-Double(hoursBeforeChabat * 3600))
        
        if reminderTime > Date() {
            await scheduleNotification(
                id: "checklist-\(hoursBeforeChabat)h",
                title: "✅ Rappel Check-list",
                body: "Plus que \(hoursBeforeChabat)h avant Chabat. Vérifiez votre liste !",
                date: reminderTime
            )
        }
    }
    
    // MARK: - Generic Schedule
    private func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        sound: UNNotificationSound? = nil
    ) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    @MainActor
    func refreshPendingNotifications() async {
        pendingNotifications = await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
}
