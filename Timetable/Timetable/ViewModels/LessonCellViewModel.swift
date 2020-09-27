//
//  LessonCellViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 27.09.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit.UIColor


class LessonCellViewModel {
    let startTime: String
    let endTime: String
    let title: String?
    let teacher: String?
    let type: String?
    let location: String
    let canceled: UIColor
    var wrongLocation: UIColor
    let note: String?
    // TODO: переименовать
    var locationColor: UIColor
    let titleColor: UIColor
    let typeColor: UIColor
    
    init(from lesson: Lesson) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        self.startTime = dateFormatter.string(from: lesson.startTime)
        self.endTime = dateFormatter.string(from: lesson.endTime)
        
        self.title = lesson.title
        self.teacher = lesson.teacherName
        
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
        
        self.type = lessonType == "" ? nil : lessonType
        
        self.note = lesson.note
        
        var locations = ""
        
        if lesson.locations != nil {
            
            for (index, location) in lesson.locations!.enumerated() {
                let location = location as! Location
                locations += "\(location.cabinet!)\n\(location.campus!)"
                if index != lesson.locations!.count - 1 { //отделяем кабинеты пустой строкой
                    locations += "\n\n"
                }
            }
        }
        self.location = locations
        
        self.wrongLocation = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
        self.locationColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if lesson.otherCampus || lesson.otherCabinet {
            self.wrongLocation = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.locationColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
        }
        
        switch lesson.form {
        case .canceled:
            self.canceled = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.wrongLocation = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.typeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.titleColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .online:
            self.canceled = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.wrongLocation = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.typeColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            self.titleColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        default:
            self.canceled = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            self.typeColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
            self.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
}
