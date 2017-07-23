//
//  Event.swift
//  Cal
//
//  Created by Soroush Shahi on 7/23/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
//

import Foundation



class Event {
    private var _day : Int
    private var _month : Int
    private var _type : EventType
    private var _isOff : Bool
    private var _desc : String
    
    
    var day : Int {
        get {
            return _day
        }
        set(newDay) {
            if newDay < 32 && newDay > 0 {
                _day = newDay
            }
        }
    }
    
    var month : Int {
        get {
            return _month
        }
        set(newMonth) {
            if newMonth < 13 && newMonth > 0 {
                _month = newMonth
            }
        }
    }
    
    var type : EventType {
        get {
            return _type
        }
        set(newType) {
                _type = newType
            
        }
    }
    
    var isOff : Bool {
        get {
            return _isOff
        }
        set(newIsOFF) {
            _isOff = newIsOFF
            
        }
    }

    var desc : String {
        get {
            return _desc
        }
        set(newDesc) {
            _desc = newDesc
            
        }
    }

    
    
    
    
    
    init(day : Int , month : Int , type : Int , isOff : Int , desc : String) {
        
        _day = day
        _month = month
        if type == 1 {
            _type = .persian
        }
        else if type == 2 {
            _type = .gregorian
        }
        else {
            _type = .islamic
        }
        
        if isOff == 1 {
        _isOff = true
        }
        else {
        _isOff = false
        }
        
        _desc = desc
        
        
        
    }
    
}
