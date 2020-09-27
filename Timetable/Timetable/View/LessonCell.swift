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
        
        //MARK: - Teacher name
        
        if lesson.teacher != nil {
            self.lessonTeacherNameBottomConstraint.constant = 8
            self.lessonTeacherNameHeightConstraint.constant = 18
        } else {
            self.lessonTeacherNameBottomConstraint.constant = 0
            self.lessonTeacherNameHeightConstraint.constant = 0
        }
        
        self.lessonTeacherNameLabel.text = lesson.teacher
        
        //MARK: - Type
        
        if lesson.type != nil {
            self.lessonTypeBottomConstraint.constant = 8
            self.lessonTypeHeightConstraint.constant = 16
        } else {
            self.lessonTypeBottomConstraint.constant = 0
            self.lessonTypeHeightConstraint.constant = 0
        }
        
        self.lessonTypeLabel.text = lesson.type
        
        //MARK: - Note
        
        if lesson.note != nil {
            self.lessonNoteBottomConstraint.constant = 8
            self.lessonNoteHeightConstraint.constant = 16
        } else {
            self.lessonNoteBottomConstraint.constant = 0
            self.lessonNoteHeightConstraint.constant = 0
        }
        
        self.lessonNoteLabel.text = lesson.note
        
        //MARK: - Locations
        
        self.lessonLocationLabel.text = lesson.location
        
        //MARK: - Colors
        
        self.otherLocationView.backgroundColor = lesson.wrongLocation
        self.lessonLocationLabel.textColor = lesson.locationColor
        self.lessonCanceledView.backgroundColor = lesson.canceled
        
        self.lessonTypeLabel.textColor = lesson.typeColor
        self.lessonTitleLabel.textColor = lesson.titleColor
    }
}
