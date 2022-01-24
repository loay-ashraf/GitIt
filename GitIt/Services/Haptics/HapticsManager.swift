//
//  HapticsManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/01/2022.
//

import UIKit

class HapticsManager {
    
    static let standard = HapticsManager()
    
    // MARK: - Feedback Generators
    
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator()
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private init() {}
    
    // MARK: - Feedback Generation Methods
    
    func sendSelectionFeedback() {
        selectionFeedbackGenerator.selectionChanged()
    }
    
    func sendImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator.impactOccurred()
    }
    
    func sendNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
}
