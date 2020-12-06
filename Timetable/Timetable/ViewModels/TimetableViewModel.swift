//
//  TimeTableViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 27.09.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class TimetableViewModel {
    
    private let coreDataManager: CoreDataManager
    private(set) var indexOfSelectedDay: Int
    var dayTitle: String {
        return getDayName()
    }
    
    private var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    private var groupCourse: String {
        return UserDefaults.standard.string(forKey: "groupCourse") ?? ""
    }
    
    private var groupSchedule: GroupSchedule?
    
    private(set) var cells: [Cell] = []
    
    enum Cell {
        case lesson(LessonCellViewModel)
        case lastUpdate(LastUpdateCellViewModel)
    }
    
    init (coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.indexOfSelectedDay = TimetableViewModel.getIndexForToday() ?? 0 //TODO: кидать ошибку?
    }
    
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cell(for indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    func selectDay(_ value: DayType) {
        switch value {
        case .today:
            guard let indexForToday = TimetableViewModel.getIndexForToday() else { return }
            self.indexOfSelectedDay = indexForToday
        case .previous:
            indexOfSelectedDay = indexOfSelectedDay == 0 ? 13: indexOfSelectedDay - 1
        case .next:
            indexOfSelectedDay = indexOfSelectedDay == 13 ? 0 : indexOfSelectedDay + 1
        case .forIndex(let index):
            if index >= 0 && index < 14 {
                indexOfSelectedDay = index
            } else {
                print("Incorrect index")
            }
        }
        configureTimetable()
    }
    
    func updateTimetable(completion: @escaping() -> ()) {
        self.groupSchedule = coreDataManager.loadGroupScheldule(profile: groupProfile, course: groupCourse)
        if let groupSchedule = self.groupSchedule {
            coreDataManager.getTimetable(for: groupSchedule) {
                completion()
            }
        }
        
    }
    
    private func configureTimetable() {
        cells.removeAll()
        guard let timetable = groupSchedule?.timetable,
              timetable.count - 1 > indexOfSelectedDay,
              let day = timetable.object(at: indexOfSelectedDay) as? Day,
              let lessons = day.lessons,
              let lastUpdate = groupSchedule?.lastUpdate,
              let lastUpdateCellViewModel = LastUpdateCellViewModel(from: lastUpdate) else { return }
        
        cells.append(.lastUpdate(lastUpdateCellViewModel))
        
        for lesson in lessons {
            cells.append(.lesson(LessonCellViewModel(from: lesson as! Lesson)))
        }
    }

    private static func getIndexForToday(_ currentDate: Date = Date()) -> Int? {
        guard let startDate = getStartDate() else { return nil }
        
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
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 6
            }
            return calendar.component(.weekday, from: currentDate) - 2
        case false:
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 13
            }
            return 6 + calendar.component(.weekday, from: currentDate) - 1
        }
    }
    
    //TODO: Получать вместе с данными о группе
    private static func getStartDate() -> Date? {
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.day = 17
        dateComponents.month = 09
        dateComponents.year = 2020
        
        return userCalendar.date(from: dateComponents)
    }
    
    private func getDayName() -> String {
        switch self.indexOfSelectedDay {
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
}

enum DayType {
    case next
    case today
    case previous
    case forIndex(Int)
}
