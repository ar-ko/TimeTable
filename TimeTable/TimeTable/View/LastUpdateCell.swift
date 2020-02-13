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
        
        
        let diffInDays = Calendar.current.dateComponents([.minute], from: groupSchedule.lastUpdate, to: Date()).minute
        var lastUpdate = ""
        
        switch diffInDays! {
        case (0):
            lastUpdate = "менее минуты назад"
        case (1...60):
            lastUpdate = "\(diffInDays!) минут назад"
        case (60...119):
            lastUpdate = "час назад"
        case (120...179):
            lastUpdate = "два часа назад"
        case (180...239):
            lastUpdate = "три часа назад"
        case (240...299):
            lastUpdate = "четыре часа назад"
        default:
            if Calendar.current.isDateInToday(groupSchedule.lastUpdate) {
                dateFormatter.dateFormat = "HH:mm"
                lastUpdate = "сегодня в \(dateFormatter.string(from: groupSchedule.lastUpdate))"
            }
            else if Calendar.current.isDateInYesterday(groupSchedule.lastUpdate) {
                dateFormatter.dateFormat = "HH:mm"
                lastUpdate = "вчера в \(dateFormatter.string(from: groupSchedule.lastUpdate))"
            }
            else {
                dateFormatter.dateFormat = "MMM d, HH:mm"
                lastUpdate = dateFormatter.string(from: groupSchedule.lastUpdate)
            }
            
        }
        
        self.lastUpdateLabel.text = "Последнее обновление: \(lastUpdate)"
    }
}
