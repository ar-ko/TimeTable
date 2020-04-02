//
//  GroupSchedule+CoreDataClass.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData

@objc(GroupSchedule)
public class GroupSchedule: NSManagedObject {
    
    lazy var indexOfSelectedDay = getIndexForToday()
    lazy var dayTitle = getDayName(currentDayIndex: indexOfSelectedDay)

    
    func setValuesForToday() {
        self.indexOfSelectedDay = getIndexForToday()
        self.dayTitle = getDayName(currentDayIndex: indexOfSelectedDay)
    }
    
    func pressedDay(_ dayIndex: Int) {
        indexOfSelectedDay = dayIndex
        dayTitle = getDayName(currentDayIndex: indexOfSelectedDay)
    }
    
    func nextDayPressed() {
        indexOfSelectedDay += 1
        if indexOfSelectedDay == timeTable.count {
            indexOfSelectedDay = 0
        }
        dayTitle = getDayName(currentDayIndex: indexOfSelectedDay)
    }
    
    func previousDayPressed() {
        indexOfSelectedDay -= 1
        if indexOfSelectedDay == -1 {
            indexOfSelectedDay = timeTable.count - 1
        }
        dayTitle = getDayName(currentDayIndex: indexOfSelectedDay)
    }
        
    private func getIndexForToday(_ currentDate: Date = Date()) -> Int {
        let startDate = getStartDate()
        
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day
        
        guard let days: Int = diffInDays else { return 0 }
        
        // Коррекция даты, находим начало недели
        let calendar = Calendar.current
        var dateCorrection = calendar.component(.weekday, from: startDate) - 2
        if calendar.component(.weekday, from: startDate) == 1 {
            dateCorrection += 7
        }
        
        let numberOfWeek = (days + dateCorrection) / 7
        
        switch numberOfWeek.isMultiple(of: 2){
        case true:
            return calendar.component(.weekday, from: currentDate) - 1
        case false:
            return 6 + calendar.component(.weekday, from: currentDate) - 1
        }
    }
    
    private func getDayName(currentDayIndex: Int) -> String {
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
            return "Воскресение, белая"
        case 7:
            return "Понедельник, синяя"
        case 8:
            return "Вторник, синяя"
        case 9:
            return "Среда, синяя"
        case 10:
            return "Четверг, синяя"
        case 11:
            return "Пятница, синяя"
        case 12:
            return "Суббота, синяя"
        case 13:
            return "Воскресение, синяя"
        default:
            return "Расписание"
        }
    }
    
    //MARK: - Set start date
    
    func getStartDate() -> Date {
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.day = 27
        dateComponents.month = 01
        dateComponents.year = 2020
        
        return userCalendar.date(from: dateComponents)!
    }
}
