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
    @IBOutlet weak var lessonTeacherLabel: UILabel!
    @IBOutlet weak var lessonTeacherNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonTeacherNameBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var lessonTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonTypeBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lessonLocationLabel: UILabel!
    
    @IBOutlet weak var lessonCanceledView: UIView!
    @IBOutlet weak var otherLocationView: UIView!
    
    @IBOutlet weak var lessonNoteLabel: UILabel!
    @IBOutlet weak var lessonNoteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonNoteBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Configure cell
    
    func configure(from lesson: LessonCellViewModel) {
        self.lessonStartTimeLabel.text = lesson.startTime
        self.lessonEndTimeLabel.text = lesson.endTime
        self.lessonTitleLabel.text = lesson.title
        self.lessonTeacherLabel.text = lesson.teacher
        self.lessonTypeLabel.text = lesson.type
        self.lessonNoteLabel.text = lesson.note
        self.lessonLocationLabel.text = lesson.location
        
        //MARK: - Constraints
        
        if lesson.teacher == nil {
            self.lessonTeacherNameBottomConstraint.constant = 0
            self.lessonTeacherNameHeightConstraint.constant = 0
        } else {
            self.lessonTeacherNameBottomConstraint.constant = 8
            self.lessonTeacherNameHeightConstraint.constant = 18
        }
                
        if lesson.type == nil {
            self.lessonTypeBottomConstraint.constant = 0
            self.lessonTypeHeightConstraint.constant = 0
        } else {
            self.lessonTypeBottomConstraint.constant = 8
            self.lessonTypeHeightConstraint.constant = 16
        }

        if lesson.note == nil {
            self.lessonNoteBottomConstraint.constant = 0
            self.lessonNoteHeightConstraint.constant = 0
        } else {
            self.lessonNoteBottomConstraint.constant = 8
            self.lessonNoteHeightConstraint.constant = 16
        }
                
        //MARK: - Colors
        
        self.otherLocationView.backgroundColor = lesson.wrongLocation
        self.lessonCanceledView.backgroundColor = lesson.canceled
        
        self.lessonLocationLabel.textColor = lesson.locationColor
        self.lessonTypeLabel.textColor = lesson.typeColor
        self.lessonTitleLabel.textColor = lesson.titleColor
    }
}
