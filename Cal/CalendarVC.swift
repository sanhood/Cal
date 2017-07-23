//
//  ViewController.swift
//  Cal
//
//  Created by Danoosh Chamani on 7/19/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
////

import UIKit
import JTAppleCalendar
import SQLite
class CalendarVC: UIViewController {

    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var Month: UILabel!
    @IBOutlet var Days : [DayLabel]!
    
    let persianTable = Table("Persian")
    let islamicTable = Table("Islamic")
    let gregorianTable = Table("Gregorian")
    var events : [Event]! = []
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CalendarCell", bundle: nil)
        calendar.register(nib, forCellWithReuseIdentifier: "Cell")
        calendar.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        calendar.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        do {
            try sqlReading()
        }catch{}
    
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.semanticContentAttribute = .forceRightToLeft
    }
    
    
    
    
    
    
    
    
    func sqlReading() throws{
        let month = Expression<Int64>("Month")
        let day = Expression<Int64>("Day")
        let off = Expression<Int64>("OFF")
        let type = Expression<Int64>("Type")
        let event = Expression<String?>("Event")
        let formatterIslamic = DateFormatter()
        let formatterGrego = DateFormatter()
        formatterIslamic.calendar = Calendar(identifier: .islamicCivil)
        formatterGrego.calendar = Calendar.current
        let bundlePath = Bundle.main.path(forResource: "Events", ofType: ".db")
        let db = try Connection(bundlePath!)
        for item in try db.prepare(persianTable){
            if item[type] == 1 || item[type] == 3 {
                events.append(Event(day: Int(item[day]), month: Int(item[month]), type: Int(item[type]), isOff: Int(item[off]), desc : item[event]!))
                
            }
        }
        for item in try db.prepare(gregorianTable){
            
            events.append(Event(day: Int(item[day]), month: Int(item[month]), type: 2, isOff: Int(item[off]), desc: item[event]!))
        }
    }

    
    
}

extension CalendarVC : JTAppleCalendarViewDelegate , JTAppleCalendarViewDataSource  {
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var cal = Calendar(identifier: .persian)
        cal.locale = Locale(identifier: "fa_IR")
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = cal.timeZone
        formatter.locale = cal.locale
        let startDate = formatter.date(from: "1395 01 01")!
        let endDate = formatter.date(from: "1410 02 01")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: cal,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: DaysOfWeek.saturday ,
                                                 hasStrictBoundaries: nil)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as! CalendarCell).Lbl.text = "fuck"
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        print("day:  \(day)")
        print("month:  \(month)")
        print("text:  \(Int(cellState.text)!)")
        print("year:   \(year)")
        print((cell as! CalendarCell).Event)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "Cell", for: indexPath) as? CalendarCell {
            cell.configure(cellState : cellState , date : date , events: events)
            
            
            return cell;
            
            
        }
        return CalendarCell()
    }
    

}


