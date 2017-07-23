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
class ViewController: UIViewController , JTAppleCalendarViewDelegate , JTAppleCalendarViewDataSource{

    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var Month: UILabel!
    let persianTable = Table("Persian")
    let islamicTable = Table("Islamic")
    let gregorianTable = Table("Gregorian")
    let month = Expression<Int64>("Month")
    let day = Expression<Int64>("Day")
    let off = Expression<Int64>("OFF")
    let type = Expression<Int64>("Type")
    let event = Expression<String?>("Event")
    let formatter = DateFormatter()
    var DataBase = [[String:Any]]()
    let islamicFirstDay = 21
    let islamicFirstMonth = 6
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try sqlReading()
        }catch{}
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sqlReading() throws{
        let formatterIslamic = DateFormatter()
        let formatterGrego = DateFormatter()
        formatterIslamic.calendar = Calendar(identifier: .islamicCivil)
        formatterGrego.calendar = Calendar.current
        let bundlePath = Bundle.main.path(forResource: "Events", ofType: ".db")
        let db = try Connection(bundlePath!)
        for item in try db.prepare(persianTable){
            if item[type] == 1 || item[type] == 3 {
                DataBase.append(["month":item[month] , "day":item[day], "off":item[off] , "type":item[type],"event":item[event]!])
            }
        }
        for item in try db.prepare(gregorianTable){
            
            DataBase.append(["month":item[month] , "day":item[day], "off":item[off] , "type":Int64(2),"event":item[event]!])
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.semanticContentAttribute = .forceRightToLeft
    }
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var cal = Calendar(identifier: .persian)
      //  cal.timeZone = TimeZone(identifier: "fa_IR")!
        cal.locale = Locale(identifier: "fa_IR")
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = cal.timeZone
        formatter.locale = cal.locale
        
        
        let startDate = formatter.date(from: "1396 01 01")!
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

    
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCell
        cell.Lbl.text = cellState.text
        cell.Lbl.textColor = UIColor.black
        
        
        
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

        cell.Event.removeAll()

        for item in DataBase {
            let month = String(describing: (item["month"]!))
            let day = String(describing: (item["day"]!))

            if ((item["type"]) as! Int64 == 3) && month == newMonth && day == newDay{
                cell.Lbl.textColor = UIColor.green
                cell.Event.append(String(describing: (item["event"])!))
                if (item["off"] as! Int64) == 1{
                    cell.Lbl.textColor = UIColor.cyan
                }
            }
            
            if ((item["type"]) as! Int64)==1 && cellState.text == day && String(persianMonth) == month{
                cell.Lbl.textColor = UIColor.green
                cell.Event.append(String(describing: item["event"]!))
                if (item["off"] as! Int64) == 1{
                    cell.Lbl.textColor = UIColor.cyan
                }
            }
            if ((item["type"] as! Int64)==2 && gregorDay == day && gregorMonth == month){
                cell.Lbl.textColor = UIColor.green
                cell.Event.append(String(describing: item["event"]!))
                if (item["off"] as! Int64) == 1{
                    cell.Lbl.textColor = UIColor.cyan
                }
            }
            
        }
        if cellState.day == .friday {
            cell.Lbl.textColor = UIColor.blue
        }
        if cellState.dateBelongsTo != .thisMonth {
            cell.Lbl.alpha = 0.45
        }
        
        
        return cell
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
    
}

