//
//  Lesson.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct Lesson {
    let startTime: Date
    let endTime: Date
    let title: String
    let teacherName: String
    let type: LessonType
    let form: LessonForm
    let subgroup: Subgroup
    let cabinet: String
    let campus: String
    let note: String
    let otherCabinet: Bool
    let otherCampus: Bool
}

enum LessonForm {case standart, online, canceled}

enum Subgroup {case first, second, general}

enum LessonType {case lecture, practice, laboratory}
