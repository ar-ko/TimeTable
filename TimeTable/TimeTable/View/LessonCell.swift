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
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonTeacherNameLabel: UILabel!
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var lessonLocationLabel: UILabel!
    
    
    func configure(with lesson: Lesson) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        self.lessonStartTimeLabel.text = dateFormatter.string(from: lesson.startTime)
        self.lessonEndTimeLabel.text = dateFormatter.string(from: lesson.endTime)
        self.lessonTitleLabel.text = lesson.title
        self.lessonTeacherNameLabel.text = lesson.teacherName
        
        switch lesson.type {
        case .laboratory: self.lessonTypeLabel.text = "Лабораторная"
        case .lecture: self.lessonTypeLabel.text = "Лекция"
        case .practice: self.lessonTypeLabel.text = "Практика"
        default: self.lessonTypeLabel.text = ""
        }
        
        self.lessonLocationLabel.text = "\(lesson.cabinet ?? "")\n\(lesson.campus ?? "")"
    }
}
