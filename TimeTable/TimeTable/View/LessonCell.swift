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
    @IBOutlet weak var lessonCanceledView: UIView!
    @IBOutlet weak var otherLocationView: UIView!
    
    @IBOutlet weak var lessonNoteLabel: UILabel!
    @IBOutlet weak var lessonNoteBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonNoteHeightConstraint: NSLayoutConstraint!
    
    
    func configure(with lesson: Lesson) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        self.lessonStartTimeLabel.text = dateFormatter.string(from: lesson.startTime)
        self.lessonEndTimeLabel.text = dateFormatter.string(from: lesson.endTime)
        self.lessonTitleLabel.text = lesson.title
        self.lessonTeacherNameLabel.text = lesson.teacherName
        
        var lessonType: String
        
        switch lesson.type {
        case .laboratory: lessonType = "Лабораторная"
        case .lecture: lessonType = "Лекция"
        case .practice: lessonType = "Практика"
        default: lessonType = ""
        }
        
        switch lesson.subgroup {
        case .first: lessonType += ", 1-я подгруппа"
        case .second: lessonType += ", 2-я подгруппа"
        default: lessonType += ""
        }
        
        self.lessonTypeLabel.text = lessonType
        self.lessonLocationLabel.text = "\(lesson.cabinet ?? "")\n\(lesson.campus ?? "")"
        print("\(lesson.cabinet ?? "")\n\(lesson.campus ?? "")\n")
        
        self.lessonNoteBottomConstraint.constant = 0
        self.lessonNoteHeightConstraint.constant = 0
        
        if lesson.note != nil {
            self.lessonNoteLabel.text = lesson.note!
            
            self.lessonNoteBottomConstraint.constant = 8
            self.lessonNoteHeightConstraint.constant = 18
        }
        
        self.otherLocationView.backgroundColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
        
        if lesson.otherCampus || lesson.otherCabinet {
            self.otherLocationView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.lessonLocationLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
        switch lesson.form {
        case .canceled:
            self.lessonCanceledView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.otherLocationView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.lessonTypeLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .online:
            self.lessonCanceledView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            self.otherLocationView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.lessonTypeLabel.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        default:
            self.lessonCanceledView.backgroundColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            self.lessonTypeLabel.textColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            break
        }
    }
}
