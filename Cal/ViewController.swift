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
        
//        for item in try db.prepare(gregorianTable){
//            
//            DataBase.append(["month":item[month] , "day":item[day], "off":item[off] , "type":item[type],"event":item[event]!])
//        }
        
//        for item in try db.prepare(islamicTable){
//            
//            DataBase.append(["month":item[month] , "day":item[day], "off":item[off] , "type":3,"event":item[event]!])
//        }


    }
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
////        let formatter = DateFormatter()
////        formatter.dateFormat = "yyy MM dd"
////        formatter.calendar = Calendar(identifier: .persian)
//        
////        formatter.timeZone = Calendar.current.timeZone
////        formatter.locale = Calendar.current.locale
//        let formatter = DateFormatter()
//        let date = Date()
//        formatter.calendar = Calendar(identifier: .persian)
//        formatter.locale = Calendar.current.locale
//        formatter.dateFormat = "dd MM yyyy"
//        
//       // print(formatter.string(from: date))
//        let start = formatter.date(from: "01 11 1395")
//        let end = formatter.date(from: "21 03 2030")
//        print(start)
//        let parameters = ConfigurationParameters(
//        return parameters
//    }
    
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
//        
//            let calendar3 = Calendar(identifier: .persian)
//        
////                formatter.locale = Calendar.current.locale
//        
//            let formatter = DateFormatter()
//            let date = Date()
//            formatter.timeZone = TimeZone(identifier:"fa_IR")
//            formatter.locale = NSLocale(localeIdentifier: "fa_IR") as Locale!
//            formatter.dateFormat = "dd MM yyyy"
//    
//           // print(formatter.string(from: date))
//            let start = formatter.date(from: "01 01 1396")!
//            let end = formatter.date(from: "21 04 1400")!
//       let parameters =  ConfigurationParameters(startDate: start, endDate: end, numberOfRows: nil, calendar: calendar3, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: DaysOfWeek.saturday, hasStrictBoundaries: nil)
//
//            return parameters
//        
//    }

    
    
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//        
//        
//        let startDate = formatter.date(from: "2017 01 01")!
//        let endDate = formatter.date(from: "2018 02 01")!
//        
//        let parameters = ConfigurationParameters(startDate: startDate,
//                                                 endDate: endDate,
//                                                 numberOfRows: nil,
//                                                 calendar: nil,
//                                                 generateInDates: nil,
//                                                 generateOutDates: nil,
//                                                 firstDayOfWeek: DaysOfWeek.saturday ,
//                                                 hasStrictBoundaries: nil)
//        return parameters
//    }

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
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.Lbl.textColor = UIColor.black
        }else {
            cell.Lbl.textColor = UIColor.gray
        }
        if cellState.day == .friday {           //jome
            cell.Lbl.textColor = UIColor.blue
        }
        
        let formatterY = DateFormatter()
        formatterY.calendar = Calendar(identifier: .persian)
        formatterY.dateFormat = "yyyy"
        
        let formatterM = DateFormatter()
        formatterM.calendar = Calendar(identifier: .persian)
        formatterM.dateFormat = "M"
        
        let formatterD = DateFormatter()
        formatterD.calendar = Calendar(identifier: .islamicCivil)

        formatterD.dateFormat = "d"
       // cell.Lbl.text = formatter2.string(from: date)
        
        
        let persianYear = Int(formatterY.string(from: date))!
        let persianMonth = Int(formatterM.string(from: date))!
        let persianDay = Int(cellState.text)!
        let n:Int = persianYear - 1396
        //let islamicMonth =
//        let islamicDay = islamicFirstDay + Int(persianDay)! - 1
//        let islamicMonth =
        let const = -(10*n+((21*n)/24)+(n/4)-(n/6))
        let Mconst = const/31
        var Dconst = const - Mconst*31
        
        
//        print(const)
//        print(islamicDay)
        print(persianYear)
        print(Mconst)
        print(Dconst)
        print("------")
        
//        formatterM.calendar = Calendar(identifier: .islamicCivil)
//        let islamicMonth = formatterM.string(from: date)
//        let islamicDay = formatterD.string(from: date)
        formatterM.calendar = Calendar.current
        formatterD.calendar = Calendar.current

        let gregorMonth = formatterM.string(from: date)
        let gregorDay = formatterD.string(from: date)
//        print(cellState.text)
//        print(islamicMonth)
//        print(islamicDay)
//        print("---------")
 
        var compareMonth = persianMonth-Mconst
        if compareMonth == 0 {
            compareMonth = 12
        }
        let compareDay = persianDay-Dconst
        
        cell.Event.removeAll()

        for item in DataBase {
            let month = String(describing: item["month"]!)
            let day = String(describing: item["day"]!)
           // print(month)
//            print(day)
//            print(persianDay+Dconst)
//            print(persianMonth+Mconst)
//            print("-----------")
//            
            if (item["type"] as! Int64 == 3) && Int(month) == compareMonth && Int(day) == compareDay {
                cell.Lbl.textColor = UIColor.green
                cell.Event.append(String(describing: item["event"]!))
            }
            
//            print(month)
//            print(day)
//            print(cellState.text)
//            print(persianMonth)
//            print("-------------")
//            if ((item["type"] as! Int)==1 && cellState.text == day && persianMonth == month) {
//                cell.Lbl.textColor = UIColor.cyan
//                cell.addEvent(event: String(describing: item["event"]!))
//                if (item["off"] as! Int64) == 1{
//                    cell.Lbl.textColor = UIColor.blue
//                }
//            }
//            if ((item["type"] as! Int)==2 && gregorDay == day && gregorMonth == month){
//                cell.Lbl.textColor = UIColor.green
//            }
//            if ((item["type"] as! Int)==3 && islamicDay == day && islamicMonth == month){
//                cell.Lbl.textColor = UIColor.purple
//                cell.addEvent(event: String(describing: item["event"]!))
//            }
            
        }
        //print(cellState)
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

