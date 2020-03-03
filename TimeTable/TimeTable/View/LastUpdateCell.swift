//
//  LastUpdateCell.swift
//  TimeTable
//
//  Created by ar_ko on 10/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class LastUpdateCell: UITableViewCell {
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    
    func configure(with groupSchedule: GroupSchedule) {
        let dateFormatter = DateFormatter()
        var lastUpdate = ""
        
        let diffInDays = Calendar.current.dateComponents([.minute], from: groupSchedule.lastUpdate!, to: Date()).minute
        
        
        if Calendar.current.isDateInToday(groupSchedule.lastUpdate!) {
            switch diffInDays! {
            case 0:
                lastUpdate = "менее минуты назад"
            case 1, 21, 31, 41, 51:
                lastUpdate = "\(diffInDays!) минуту назад"
            case 2...4, 22...24, 32...34, 42...44, 52...54:
                lastUpdate = "\(diffInDays!) минуты назад"
            case 5...20, 25...30, 35...40, 45...50, 55...59:
                lastUpdate = "\(diffInDays!) минут назад"
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
                lastUpdate = "сегодня в \(dateFormatter.string(from: groupSchedule.lastUpdate!))"
            }
        }
        else if Calendar.current.isDateInYesterday(groupSchedule.lastUpdate!) {
            dateFormatter.dateFormat = "HH:mm"
            lastUpdate = "вчера в \(dateFormatter.string(from: groupSchedule.lastUpdate!))"
        } else {
            dateFormatter.dateFormat = "d MMM, HH:mm"
            lastUpdate = dateFormatter.string(from: groupSchedule.lastUpdate!)
        }
        self.lastUpdateLabel.text = "Последнее обновление: \(lastUpdate)"
    }
}
