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
    @IBOutlet weak var HighlightedView : HighlightView!
    @IBOutlet weak var eventView : UIView!
    var Event = [String]()
    
    func configure(cellState : CellState , date : Date , events : [Event]) {
        self.selectOrDeselectMe()
        self.configureBeauties()
        self.Lbl.text = cellState.text
        self.Lbl.textColor = UIColor.black
        self.eventView.isHidden = true
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
        var n:Int = persianYear-1396
        
        var newDay = String(persianDay)
        var newMonth = String(persianMonth)
        
        if persianYear != 1396 {
            var interval = 0
            if n>0{
                interval = ((((10*24)+21)*n)+((n/4)*24)+((1+n/6))*24)*60*60
            }else{
                n *= -1
                interval = -1*((((10*24)+21)*n)+((n/4)*24)+((1+n/6))*24)*60*60
            }
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
        
        for event in events {
            let month = String(event.month)
            let day = String(event.day)
            
            if event.type == .islamic && month == newMonth && day == newDay{
                eventView.isHidden = false
                self.Event.append(String(event.desc))
                if event.isOff {
                    self.Lbl.textColor = UIColor(colorLiteralRed: 194/255, green: 18/255, blue: 4/255, alpha: 0.8)
                }
            }
            
            if event.type == .persian && cellState.text == day && String(persianMonth) == month{
                eventView.isHidden = false
                self.Event.append(String(event.desc))
                if event.isOff {
                    self.Lbl.textColor = UIColor.red
                }
            }
            if event.type == .gregorian && gregorDay == day && gregorMonth == month {
                eventView.isHidden = false
                self.Event.append(String(event.desc))
                if event.isOff {
                    self.Lbl.textColor = UIColor.red
                }
            }
            
        }
        if cellState.day == .friday {
            self.Lbl.textColor = UIColor.red
        }
        if cellState.dateBelongsTo != .thisMonth {
            self.Lbl.alpha = 0.4
        }
        
    }
    
    func configureBeauties () {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(colorLiteralRed: 128 / 256, green: 0, blue: 128/256, alpha: 0.8).cgColor
        self.bounds.size = CGSize(width: 40, height: 40)

    }
    
    
    func selectOrDeselectMe () {
        if self.isSelected {
            
            self.HighlightedView.isHidden = false
            self.HighlightedView.didUnHidden()
        }
        else {
            self.HighlightedView.isHidden = true
        }
    }
    
}


