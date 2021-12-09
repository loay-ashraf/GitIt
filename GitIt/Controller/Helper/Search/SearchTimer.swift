//
//  SearchTimer.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation

class SearchTimer {

    let shortInterval: TimeInterval
    let longInterval: TimeInterval
    let callback: () -> Void

    var shortTimer: Timer?
    var longTimer: Timer?

    enum Const {
        // Auto-search at least this frequently while typing
        static let longAutosearchDelay: TimeInterval = 2.0
        // Trigger automatically after a pause of this length
        static let shortAutosearchDelay: TimeInterval = 0.5
    }

    init(short: TimeInterval = Const.shortAutosearchDelay,
         long: TimeInterval = Const.longAutosearchDelay,
         callback: @escaping () -> Void)
    {
        shortInterval = short
        longInterval = long
        self.callback = callback
    }

    func activate() {
        shortTimer?.invalidate()
        shortTimer = Timer.scheduledTimer(withTimeInterval: shortInterval, repeats: false)
            { [weak self] _ in self?.fire() }
        if longTimer == nil {
            longTimer = Timer.scheduledTimer(withTimeInterval: longInterval, repeats: false)
                { [weak self] _ in self?.fire() }
        }
    }

    func cancel() {
        shortTimer?.invalidate()
        longTimer?.invalidate()
        shortTimer = nil; longTimer = nil
    }

    private func fire() {
        cancel()
        callback()
    }

}
