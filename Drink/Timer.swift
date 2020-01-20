//
//  Reminder.swift
//  Drink
//
//  Created by Tony on 1/18/20.
//  Copyright © 2020 Tony. All rights reserved.
//

import Foundation

class MyTimer {
    private var interval: Int
    private var counter: Int
    private var RepeatedTimes: Int
    private var isOn: Bool
    private var action: ((_ repeatedTimes: Int)->Void)!
    private var remainUpdater: ((_ remain: Int)->Void)? = nil
    private var timer: Timer!
    
    init() {
        self.interval = 0
        self.counter = 0
        self.RepeatedTimes = 0
        self.isOn = false
        self.timer = nil
        self.action = nil
    }
    
    init(_ interval: Int, action: @escaping (_ repeatedTimes: Int)->Void) {
        self.interval = interval
        self.counter = interval
        self.RepeatedTimes = 0
        self.isOn = true
        self.action = action
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updater), userInfo: nil, repeats: true)
    }
    
    func start(_ interval: Int, action: @escaping (_ repeatedTimes: Int)->Void, remainUpdater: ((_ remain: Int)->Void)?) {
        self.interval = interval
        self.counter = interval
        self.RepeatedTimes = 0
        self.isOn = true
        self.action = action
        self.remainUpdater = remainUpdater!
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updater), userInfo: nil, repeats: true)
    }
    
    func stop() -> Int {
        timer.invalidate()
        return RepeatedTimes
    }
    
    func immediateDo(){
        counter = 0
    }
    
    @objc private func updater() {
        counter -= 1
        if counter <= 0 {
            self.RepeatedTimes += 1
            action(RepeatedTimes)
            counter = interval
        }
        if remainUpdater != nil {
            remainUpdater!(counter)
        }
    }
}
