//
//  Globals.swift
//  Cal
//
//  Created by Soroush Shahi on 7/23/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
//

import Foundation
import SQLite


enum EventType {
    case islamic
    case persian
    case gregorian
}

let month = Expression<Int64>("Month")
let day = Expression<Int64>("Day")
let off = Expression<Int64>("OFF")
let type = Expression<Int64>("Type")
let event = Expression<String?>("Event")
