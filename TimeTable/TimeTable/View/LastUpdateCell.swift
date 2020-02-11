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
        dateFormatter.dateFormat = "MMM d, HH:mm"
        let lastUpdate = dateFormatter.string(from: groupSchedule.lastUpdate)
        
        self.lastUpdateLabel.text = "Последнее обновление: \(lastUpdate)"
    }
}
