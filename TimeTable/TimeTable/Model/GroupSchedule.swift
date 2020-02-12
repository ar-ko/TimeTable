//
//  TimeTable.swift
//  TimeTable
//
//  Created by ar_ko on 08/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation
import CoreData


struct GroupSchedule {
    var timeTable: [[Lesson]]
    lazy var indexOfSelectedDay = getIndexOfSelectedDay(from: self.getStartDate())
    var groupInfo: Group
    lazy var dayTitle = getWeekName(currentDayIndex: indexOfSelectedDay)
    var lastUpdate: Date
    
    
    init(timeTable: [[Lesson]], group: Group) {
        self.timeTable = timeTable
        self.groupInfo = group
        self.lastUpdate = Date()
    }
    
    mutating func nextDayPressed() {
        indexOfSelectedDay += 1
        if indexOfSelectedDay == timeTable.count {
            indexOfSelectedDay = 0
        }
        dayTitle = getWeekName(currentDayIndex: indexOfSelectedDay)
    }
    
    mutating func previousDayPressed() {
        indexOfSelectedDay -= 1
        if indexOfSelectedDay == -1 {
            indexOfSelectedDay = timeTable.count - 1
        }
        dayTitle = getWeekName(currentDayIndex: indexOfSelectedDay)
    }
    
    func saveGroupSchedule() {
        
        // MARK: - ToDo
        
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
