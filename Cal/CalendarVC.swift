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
class CalendarVC: UIViewController  {

    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var MonthYear: UILabel!
    @IBOutlet var Days : [DayLabel]!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var inputYear: UITextField!
    @IBOutlet weak var inputMonth: UITextField!
    @IBOutlet weak var inputDay: UITextField!
    @IBOutlet weak var perGreSegment: UISegmentedControl!


    
    let persianTable = Table("Persian")
    let islamicTable = Table("Islamic")
    let gregorianTable = Table("Gregorian")
    var events : [Event]! = []
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        calendar.layer.shadowColor = UIColor.purple.cgColor
        calendar.layer.shadowRadius = 5
        calendar.layer.shadowOpacity = 0.3
        calendar.clipsToBounds = false
       // calendar.layer.masksToBounds = false
        //calendar.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        do {
            try sqlReading()
        }catch{}
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.semanticContentAttribute = .forceRightToLeft
        let date = Date()
        calendar.scrollToDate(date)
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
    
    
    @IBAction func goTo(_ sender: Any) {
        if perGreSegment.selectedSegmentIndex == 1 {
        let date = Date()
        let cal = Calendar(identifier: .persian)
        var dateComponents = cal.dateComponents([.day,.month,.year], from:date)
        dateComponents.day = Int(inputDay.text!)
        dateComponents.month = Int(inputMonth.text!)
        dateComponents.year = Int(inputYear.text!)
            if !dateComponents.isValidDate {
//                notValidDateAlert()
//                return
                print("not valid")
            }
        let gotoDate = cal.date(from: dateComponents)
        calendar.scrollToDate(gotoDate!)
            calendar.selectDates([gotoDate!])}
        else {
            let date = Date()
            let cal = Calendar(identifier: .gregorian)
            var dateComponents = cal.dateComponents([.day,.month,.year], from:date)
            dateComponents.day = Int(inputDay.text!)
            dateComponents.month = Int(inputMonth.text!)
            dateComponents.year = Int(inputYear.text!)
            if !dateComponents.isValidDate {
//                notValidDateAlert()
//                return
                print("not valid")
            }
            let gotoDate = cal.date(from: dateComponents)
            calendar.scrollToDate(gotoDate!)
            calendar.selectDates([gotoDate!])
        }
        
        view.endEditing(true)
    }
    
    
    func notValidDateAlert () {
        let alert = UIAlertController(title: "خطا", message: "تاریخ وارد شده صحیح نیست", preferredStyle: .alert)
        let action = UIAlertAction(title: "باشه", style: .default, handler: {
            void in
            self.view.endEditing(true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
        guard let selectedCell = cell as? CalendarCell else {return}
        if selectedCell.Event.count > 0 {
            eventLbl.text = ""
            for event in selectedCell.Event {
                eventLbl.text = eventLbl.text! + "\(event)\n"
            }
        }
        else {
            eventLbl.text = ""
        }
        selectedCell.selectOrDeselectMe()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCell {
            cell.configure(cellState : cellState , date : date , events: events)
            return cell;
        }
        return CalendarCell()
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date!)
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date!)
        MonthYear.text = year + "-" + month
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let myCell = cell as? CalendarCell else {return}
        
        myCell.selectOrDeselectMe()
    }

}



