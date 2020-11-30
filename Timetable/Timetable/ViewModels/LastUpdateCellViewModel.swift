//
//  LastUpdateCellViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 28.09.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class LastUpdateCellViewModel {
    let lastUpdate: String?
    
    init?(from updateDate: Date) {
        let dateFormatter = DateFormatter()
        var lastUpdate = ""
        
        guard let diffInDays = Calendar.current.dateComponents([.minute], from: updateDate, to: Date()).minute else { return nil }
        
        if Calendar.current.isDateInToday(updateDate) {
            switch diffInDays {
            case 0:
                lastUpdate = "менее минуты назад"
            case 1, 21, 31, 41, 51:
                lastUpdate = "\(diffInDays) минуту назад"
            case 2...4, 22...24, 32...34, 42...44, 52...54:
                lastUpdate = "\(diffInDays) минуты назад"
            case 5...20, 25...30, 35...40, 45...50, 55...59:
                lastUpdate = "\(diffInDays) минут назад"
            case 60...119:
                lastUpdate = "час назад"
            case 120...179:
                lastUpdate = "два часа назад"
            case 180...239:
                lastUpdate = "три часа назад"
            case 240...299:
                lastUpdate = "четыре часа назад"
            default:
                dateFormatter.dateFormat = "HH:mm"
                lastUpdate = "сегодня в \(dateFormatter.string(from: updateDate))"
            }
        } else if Calendar.current.isDateInYesterday(updateDate) {
            dateFormatter.dateFormat = "HH:mm"
            lastUpdate = "вчера в \(dateFormatter.string(from: updateDate))"
        } else {
            dateFormatter.dateFormat = "d MMM, HH:mm"
            lastUpdate = dateFormatter.string(from: updateDate)
        }
        self.lastUpdate = "Последнее обновление: \(lastUpdate)"
    }
}
