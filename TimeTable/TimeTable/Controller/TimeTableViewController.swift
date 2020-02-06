//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


let firstGroup = Group(name: "Экономика и управление", curse: "1", semestrDate: "27.01.20-04.04.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "B", startRow: 11, endColumn: "E", endRow: 175)
let secondGroup = Group(name: "Сервис мехатронных систем", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "N", startRow: 11, endColumn: "Q", endRow: 175)
var indexOfSelectedDay = 0


class TimeTableViewController: UIViewController {

    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    var timeTable = [[Lesson]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeTableNetworkService.getTimeTable(group: firstGroup) { (response) in
            guard let response = response else { return }
            self.timeTable = response.timeTable
            indexOfSelectedDay = self.getIndexOfSelectedDay(from: self.getStartDate())
            self.dayTitle.text = self.getWeekName(currentDayIndex: indexOfSelectedDay)
            self.timeTableView.reloadData()
        }
    }
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
        
        if !self.timeTable.isEmpty {
        let lessons = self.timeTable[indexOfSelectedDay][indexPath.row]
        cell.configure(with: lessons)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable.isEmpty ? 0:timeTable[indexOfSelectedDay].count
    }
}

extension TimeTableViewController {
    @IBAction func previousDayPressed(_ sender: UIButton) {
        indexOfSelectedDay -= 1
        if indexOfSelectedDay == -1 {
            indexOfSelectedDay = timeTable.count - 1
        }
        dayTitle.text = getWeekName(currentDayIndex: indexOfSelectedDay)
        
        self.timeTableView.reloadData()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        indexOfSelectedDay += 1
        if indexOfSelectedDay == timeTable.count {
            indexOfSelectedDay = 0
        }
        dayTitle.text = getWeekName(currentDayIndex: indexOfSelectedDay)
        
        self.timeTableView.reloadData()
    }
    
    func getIndexOfSelectedDay(from startDate: Date) -> Int {
        let currentDate = Date()
        
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day
        
        guard let days: Int = diffInDays else {
            print("TYT")
            return 0
        }
        
        // Коррекция даты, находим начало недели
        let calendar = Calendar.current
        var dateCorrection = calendar.component(.weekday, from: startDate) - 2
        if calendar.component(.weekday, from: startDate) == 1 {
            dateCorrection += 7
        }
        
        let numberOfWeek = (days + dateCorrection) / 7
        
        switch numberOfWeek.isMultiple(of: 2){
        case true:
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 6
            }
            else { return calendar.component(.weekday, from: currentDate) - 2 }
        case false:
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 0
            } else { return 6 + calendar.component(.weekday, from: currentDate) - 2 }
        }
    }
    
    func getStartDate() -> Date {
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.day = 27
        dateComponents.month = 01
        dateComponents.year = 2020
        return userCalendar.date(from: dateComponents)!
    }
    
    func getWeekName(currentDayIndex: Int) -> String {
        switch currentDayIndex {
        case 0:
            return "Понедельник, белая"
        case 1:
            return "Вторник, белая"
        case 2:
            return "Среда, белая"
        case 3:
            return "Четверг, белая"
        case 4:
            return "Пятница, белая"
        case 5:
            return "Суббота, белая"
        case 6:
            return "Понедельник, синяя"
        case 7:
            return "Вторник, синяя"
        case 8:
            return "Среда, синяя"
        case 9:
            return "Четверг, синяя"
        case 10:
            return "Пятница, синяя"
        case 11:
            return "Суббота, синяя"
        default:
            return "Расписание"
        }
    }
}

