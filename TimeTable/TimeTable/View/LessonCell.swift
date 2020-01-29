//
//  Lesson.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class LessonCell: UITableViewCell {
    
    @IBOutlet weak var lessonStartTimeLabel: UILabel!
    @IBOutlet weak var lessonEndTimeLabel: UILabel!

    
    func configure(with lesson: Lesson) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        self.lessonStartTimeLabel.text = dateFormatter.string(from: lesson.startTime)
        self.lessonStartTimeLabel.text = dateFormatter.string(from: lesson.endTime)
        
    }
}
