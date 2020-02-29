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
    
    @IBOutlet weak var mainInformationStackView: UIStackView!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonTeacherNameLabel: UILabel!
    @IBOutlet weak var lessonTypeDownConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var lessonTypeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lessonLocationLabel: UILabel!
    
    @IBOutlet weak var lessonCanceledView: UIView!
    @IBOutlet weak var otherLocationView: UIView!
    
    @IBOutlet weak var lessonNoteDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonNoteLabel: UILabel!
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
        
        if lessonType == "" {
            if #available(iOS 11.0, *) {
                self.mainInformationStackView.setCustomSpacing(0, after: self.lessonTypeLabel)
            } else {
                self.lessonTypeDownConstraint.constant = 0
            }
            self.lessonTypeHeightConstraint.constant = 0
            self.lessonTypeLabel.text = nil
            
        }
        else {
            self.lessonTypeLabel.text = lessonType
            if #available(iOS 11.0, *) {
                self.mainInformationStackView.setCustomSpacing(8, after: self.lessonTypeLabel)
            } else {
                self.lessonTypeDownConstraint.constant = 8
            }
            self.lessonTypeHeightConstraint.constant = 16
        }
        
        if lesson.locations != nil {
            var locations = ""
            for (index, location) in lesson.locations!.enumerated() {
                let location = location as! Location
                locations += "\(location.cabinet!)\n\(location.campus!)"
                if index != lesson.locations!.count - 1 {
                    locations += "\n\n"
                }
            }
            self.lessonLocationLabel.text = locations
        }
        
        if lesson.note != nil {
            self.lessonNoteLabel.text = lesson.note!
            
            if #available(iOS 11.0, *) {
                self.mainInformationStackView.setCustomSpacing(8, after: self.lessonNoteLabel)
            } else {
                self.lessonNoteDownConstraint.constant = 8
            }
            self.lessonNoteHeightConstraint.constant = 16
        }
        else {
            self.lessonNoteLabel.text = nil
            
            if #available(iOS 11.0, *) {
                self.mainInformationStackView.setCustomSpacing(0, after: self.lessonNoteLabel)
            } else {
                self.lessonNoteDownConstraint.constant = 0
            }
            self.lessonNoteHeightConstraint.constant = 0
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
            self.lessonTitleLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .online:
            self.lessonCanceledView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.otherLocationView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.lessonTypeLabel.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.lessonTitleLabel.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        default:
            self.lessonCanceledView.backgroundColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            self.lessonTypeLabel.textColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            self.lessonTitleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
