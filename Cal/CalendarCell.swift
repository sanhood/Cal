//
//  CalendarCell.swift
//  Cal
//
//  Created by Danoosh Chamani on 7/20/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CalendarCell: JTAppleCell {
    @IBOutlet weak var Lbl : UILabel!
    var Event = [String]()
    
    func configure(cellState : CellState , date : Date , DataBase : [[String : Any]]) {
        self.Lbl.text = cellState.text
        self.Lbl.textColor = UIColor.black
        self.Lbl.alpha = 1
        let formatterY = DateFormatter()
        formatterY.calendar = Calendar(identifier: .persian)
        formatterY.dateFormat = "yyyy"
        
        let formatterM = DateFormatter()
        formatterM.calendar = Calendar(identifier: .persian)
        formatterM.dateFormat = "M"
        
        let formatterD = DateFormatter()
        formatterD.calendar = Calendar(identifier: .islamicCivil)
        
        formatterD.dateFormat = "d"
        
        
        let persianYear = Int(formatterY.string(from: date))!
        let persianMonth = Int(formatterM.string(from: date))!
        let persianDay = Int(cellState.text)!
        let n:Int = persianYear-1396
        
        var newDay = String(persianDay)
        var newMonth = String(persianMonth)
        
        if persianYear != 1396 {
            let interval = ((((10*24)+21)*n)+((n/4)*24)+((1+n/6))*24)*60*60
            
            print(interval)
            let newDate = date.addingTimeInterval(TimeInterval(interval))
            let formatter1 = DateFormatter()
            formatter1.calendar = Calendar(identifier: .persian)
            formatter1.dateFormat = "M"
            
            let formatter2 = DateFormatter()
            formatter2.calendar = Calendar(identifier: .persian)
            formatter2.dateFormat = "d"
            
            newDay = formatter2.string(from: newDate)
            newMonth = formatter1.string(from: newDate)
            
        }
        
        formatterM.calendar = Calendar.current
        formatterD.calendar = Calendar.current
        
        let gregorMonth = formatterM.string(from: date)
        let gregorDay = formatterD.string(from: date)
        
        self.Event.removeAll()
        
        for item in DataBase {
            let month = String(describing: (item["month"]!))
            let day = String(describing: (item["day"]!))
            
            if ((item["type"]) as! Int64 == 3) && month == newMonth && day == newDay{
                self.Lbl.textColor = UIColor.green
                self.Event.append(String(describing: (item["event"])!))
                if (item["off"] as! Int64) == 1{
                    self.Lbl.textColor = UIColor.cyan
                }
            }
            
            if ((item["type"]) as! Int64)==1 && cellState.text == day && String(persianMonth) == month{
                self.Lbl.textColor = UIColor.green
                self.Event.append(String(describing: item["event"]!))
                if (item["off"] as! Int64) == 1{
                    self.Lbl.textColor = UIColor.cyan
                }
            }
            if ((item["type"] as! Int64)==2 && gregorDay == day && gregorMonth == month){
                self.Lbl.textColor = UIColor.green
                self.Event.append(String(describing: item["event"]!))
                if (item["off"] as! Int64) == 1{
                    self.Lbl.textColor = UIColor.cyan
                }
            }
            
        }
        if cellState.day == .friday {
            self.Lbl.textColor = UIColor.blue
        }
        if cellState.dateBelongsTo != .thisMonth {
            self.Lbl.alpha = 0.45
        }
        
    }
}


