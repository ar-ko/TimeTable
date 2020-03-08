//
//  TimeTableJSONParser.swift
//  TimeTable
//
//  Created by ar_ko on 03/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation
import CoreData


extension GetTimeTableResponse {
    
    
    func getDaysSeparator(json: TimeTableJSON, rangeIndexes: (startColumnIndex: Int, startRowIndex: Int)) -> [Int] {
        var merges = json.sheets.last!.merges
        
        merges = merges.filter { $0.startColumnIndex == rangeIndexes.startColumnIndex && $0.endColumnIndex == rangeIndexes.startColumnIndex + 1}
        merges.sort { $0.startRowIndex < $1.startRowIndex }
        
        var rowIndex = rangeIndexes.startRowIndex
        var separatorIndex = 0
        var daysSeparator = [Int]()
        
        for merge in merges {
            if merge.startRowIndex == rowIndex {
                separatorIndex += 4
                rowIndex = merge.endRowIndex
            }
            else {
                daysSeparator.append((daysSeparator.last ?? 0) + separatorIndex)
                separatorIndex = 5
                rowIndex = merge.endRowIndex
            }
        }
        
        return daysSeparator
    }
    
    func JSONParser(json: TimeTableJSON, daysSeparator: [Int], context: NSManagedObjectContext, rangeIndexes: (startColumnIndex: Int, startRowIndex: Int)) -> [Day] {
        var whiteWeekTimetable = [Day]()
        var blueWeekTimetable = [Day]()
        
        for sheet in json.sheets {
            for data in sheet.data {
                var whiteWeekDayLessons = [Lesson]()
                var blueWeekDayLessons = [Lesson]()
                
                var correctionIndex = 0
                
                var lessonStartTime: String?
                
                var whiteWeekLessonTitle: String?
                var whiteWeekSubgroup: Subgroup = .none
                var whiteWeekTeacherName: String?
                var whiteWeekLessonType: LessonType = .none
                var whiteWeekLessonForm: LessonForm = .none
                var whiteWeekCampus: String?
                var whiteWeekOtherCampus = false
                var whiteWeekCabinet: String?
                var whiteWeekOtherCabinet = false
                var whiteWeekNote: String?
                
                var blueWeekLessonTitle: String?
                var blueWeekSubgroup: Subgroup = .none
                var blueWeekTeacherName: String?
                var blueWeekLessonType: LessonType = .none
                var blueWeekLessonForm: LessonForm = .none
                var blueWeekCampus: String?
                var blueWeekOtherCampus = false
                var blueWeekCabinet: String?
                var blueWeekOtherCabinet = false
                var blueWeekNote: String?
                
                for (rowIndex, rowData) in data.rowData.enumerated(){
                    if daysSeparator.contains(rowIndex) {
                        whiteWeekTimetable.append(createDay(lessons: whiteWeekDayLessons, context: context))
                        blueWeekTimetable.append(createDay(lessons: blueWeekDayLessons, context: context))
                        
                        whiteWeekDayLessons = []
                        blueWeekDayLessons = []
                        
                        correctionIndex += 1
                        continue
                    }
                    
                    for (columnIndex, value) in rowData.values.enumerated() {
                        switch (rowIndex - correctionIndex) % 4 {
                        case 0:
                            switch columnIndex % 4 {
                            case 0:
                                lessonStartTime = value.formattedValue
                            case 1:
                                if value.formattedValue != nil {
                                    if cellIsMerged(in: json, columnIndex: rangeIndexes.startColumnIndex + columnIndex,
                                                    rowIndex: rangeIndexes.startRowIndex + rowIndex) {
                                        whiteWeekSubgroup = .general
                                    }
                                    else {
                                        whiteWeekSubgroup = .first
                                    }
                                    whiteWeekLessonTitle = value.formattedValue
                                    whiteWeekLessonForm = getLessonForm(effectiveFormat: value.effectiveFormat!)
                                    whiteWeekNote = value.note
                                }
                            case 2:
                                if value.formattedValue != nil {
                                    whiteWeekLessonTitle = value.formattedValue
                                    whiteWeekSubgroup = .second
                                    whiteWeekNote = value.note
                                    whiteWeekLessonForm = getLessonForm(effectiveFormat: value.effectiveFormat!)
                                }
                            case 3:
                                if value.formattedValue != nil {
                                    whiteWeekCabinet = value.formattedValue
                                    whiteWeekOtherCabinet = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        case 1:
                            switch columnIndex % 4 {
                            case 0:
                                lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1:
                                whiteWeekTeacherName = value.formattedValue
                            case 2:
                                whiteWeekTeacherName = whiteWeekTeacherName == nil ? value.formattedValue: whiteWeekTeacherName
                            case 3:
                                if value.formattedValue != nil {
                                    whiteWeekCampus = value.formattedValue
                                    whiteWeekOtherCampus = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        case 2:
                            switch columnIndex % 4 {
                            case 0:
                                lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1:
                                if value.formattedValue != nil {
                                    if cellIsMerged(in: json, columnIndex: rangeIndexes.startColumnIndex + columnIndex, rowIndex: rangeIndexes.startRowIndex + rowIndex) {
                                        blueWeekSubgroup = .general
                                    }
                                    else {
                                        blueWeekSubgroup = .first
                                    }
                                    blueWeekLessonTitle = value.formattedValue
                                    blueWeekNote = value.note
                                    blueWeekLessonForm = getLessonForm(effectiveFormat: value.effectiveFormat!)
                                }
                            case 2:
                                if value.formattedValue != nil {
                                    blueWeekLessonTitle = value.formattedValue
                                    blueWeekSubgroup = .second
                                    blueWeekNote = value.note
                                    blueWeekLessonForm = getLessonForm(effectiveFormat: value.effectiveFormat!)
                                }
                            case 3:
                                if value.formattedValue != nil {
                                    blueWeekCabinet = value.formattedValue
                                    blueWeekOtherCabinet = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        case 3:
                            switch columnIndex % 4 {
                            case 0:
                                lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1:
                                blueWeekTeacherName = value.formattedValue
                            case 2:
                                blueWeekTeacherName = blueWeekTeacherName == nil ? value.formattedValue: blueWeekTeacherName
                            case 3:
                                if value.formattedValue != nil {
                                    blueWeekCampus = value.formattedValue
                                    blueWeekOtherCampus = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        default: print ("rowNumber out of range")
                        }
                    }
                    
                    if ((rowIndex - correctionIndex) % 4 == 3) || (rowIndex == data.rowData.count - 1) {
                        if whiteWeekNote != nil {
                            whiteWeekNote = textFormatting(text: whiteWeekNote!)
                        }
                        if blueWeekNote != nil {
                            blueWeekNote = textFormatting(text: blueWeekNote!)
                        }
                        
                        if whiteWeekTeacherName != nil {
                            whiteWeekTeacherName = whiteWeekTeacherName!.prefix(1).capitalized + whiteWeekTeacherName!.dropFirst()
                        }
                        if blueWeekTeacherName != nil {
                            blueWeekTeacherName = blueWeekTeacherName!.prefix(1).capitalized + blueWeekTeacherName!.dropFirst()
                        }
                        
                        let whiteWeekLocation = getLocations(of: whiteWeekCabinet, and: whiteWeekCampus, context: context)
                        let blueWeekLocation = getLocations(of: blueWeekCabinet, and: blueWeekCampus, context: context)
                        
                        let startTime = timeParser(dateString: lessonStartTime!)!
                        
                        if whiteWeekLessonTitle != nil {
                            let lesson = Lesson(context: context)
                            
                            whiteWeekLessonType = getLessonType(lessonTitle: whiteWeekLessonTitle!)
                            whiteWeekLessonTitle = textFormatting(text: whiteWeekLessonTitle!, lessonType: whiteWeekLessonType)
                            
                            lesson.startTime = startTime
                            lesson.title = whiteWeekLessonTitle
                            lesson.teacherName = whiteWeekTeacherName
                            lesson.type = whiteWeekLessonType
                            lesson.form = whiteWeekLessonForm
                            lesson.subgroup = whiteWeekSubgroup
                            
                            if whiteWeekLocation != nil {
                                lesson.locations = NSOrderedSet(array: whiteWeekLocation!)
                            }
                            
                            lesson.note = whiteWeekNote
                            lesson.otherCabinet = whiteWeekOtherCabinet
                            lesson.otherCampus = whiteWeekOtherCampus
                            
                            whiteWeekDayLessons.append(lesson)
                        }
                        
                        if blueWeekLessonTitle != nil {
                            let lesson = Lesson(context: context)
                            
                            blueWeekLessonType = getLessonType(lessonTitle: blueWeekLessonTitle!)
                            blueWeekLessonTitle = textFormatting(text: blueWeekLessonTitle!, lessonType: blueWeekLessonType)
                            
                            lesson.startTime = startTime
                            lesson.title = blueWeekLessonTitle
                            lesson.teacherName = blueWeekTeacherName
                            lesson.type = blueWeekLessonType
                            lesson.form = blueWeekLessonForm
                            lesson.subgroup = blueWeekSubgroup
                            
                            if blueWeekLocation != nil {
                                lesson.locations = NSOrderedSet(array: blueWeekLocation!)
                            }
                            
                            lesson.note = blueWeekNote
                            lesson.otherCabinet = blueWeekOtherCabinet
                            lesson.otherCampus = blueWeekOtherCampus
                            
                            blueWeekDayLessons.append(lesson)
                        }
                        
                        lessonStartTime = nil
                        
                        whiteWeekLessonTitle = nil
                        whiteWeekSubgroup = Subgroup.none
                        whiteWeekTeacherName = nil
                        whiteWeekLessonForm = LessonForm.none
                        whiteWeekLessonType = LessonType.none
                        whiteWeekCampus = nil
                        whiteWeekOtherCampus = false
                        whiteWeekCabinet = nil
                        whiteWeekOtherCabinet = false
                        whiteWeekNote = nil
                        
                        blueWeekLessonTitle = nil
                        blueWeekSubgroup = Subgroup.none
                        blueWeekTeacherName = nil
                        blueWeekLessonForm = LessonForm.none
                        whiteWeekLessonType = LessonType.none
                        blueWeekCampus = nil
                        blueWeekOtherCampus = false
                        blueWeekCabinet = nil
                        blueWeekOtherCabinet = false
                        blueWeekNote = nil
                    }
                }
                whiteWeekTimetable.append(createDay(lessons: whiteWeekDayLessons, context: context))
                blueWeekTimetable.append(createDay(lessons: blueWeekDayLessons, context: context))
            }
        }
        return whiteWeekTimetable + blueWeekTimetable
    }
    
    func createDay(lessons: [Lesson], context: NSManagedObjectContext) -> Day {
        let day = Day(context: context)
        day.lessons = NSOrderedSet(array: lessons)
        
        return day
    }
    
    func cellIsMerged(in json: TimeTableJSON, columnIndex:Int, rowIndex:Int ) -> Bool {
        for sheet in json.sheets {
            for merge in sheet.merges {
                if merge.startColumnIndex == columnIndex && merge.startRowIndex == rowIndex {
                    return true
                }
            }
        }
        return false
    }
    
    func getLessonForm(effectiveFormat: EffectiveFormat) -> LessonForm {
        switch (effectiveFormat.textFormat.foregroundColor.red, effectiveFormat.textFormat.foregroundColor.green, effectiveFormat.textFormat.foregroundColor.blue) {
        case (0.6, nil, 1):
            return .online
        case (1, nil, nil):
            return .canceled
        default:
            return .standart
        }
    }
    
    func getLessonType(lessonTitle: String) -> LessonType {
        let lessonTitle = lessonTitle.lowercased()
        if lessonTitle.contains("(лб)") {
            return .laboratory
        }
        else if lessonTitle.contains("(лк)") {
            return .lecture
        }
        else if lessonTitle.contains("(пр)") || lessonTitle.contains("(ознакомительная)") {
            return .practice
        }
        return LessonType.none
    }
    
    func textFormatting (text: String, lessonType: LessonType = LessonType.none) -> String {
        var lessonTypeString: String?
        var text = text.lowercased()
        
        switch lessonType {
        case .laboratory:
            lessonTypeString = "(лб)"
        case .practice:
            lessonTypeString = "(пр)"
        case .lecture:
            lessonTypeString = "(лк)"
        default:
            lessonTypeString = nil
        }
        
        if lessonType != LessonType.none {
            if let index = text.range(of: lessonTypeString!)?.lowerBound {
                text = String(text[..<index])
            }
        }
        
        var result = ""
        text.uppercased().enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .bySentences) { (sub, _, _, _)  in
            result += String(sub!.prefix(1))
            result += String(sub!.dropFirst(1)).lowercased()
        }
        
        return result
    }
    
    func locationIsBroken(effectiveFormat: EffectiveFormat) -> Bool {
        if effectiveFormat.backgroundColor.red == 1 &&
            effectiveFormat.backgroundColor.green == nil &&
            effectiveFormat.backgroundColor.blue == nil {
            return true
        } else {
            return false
        }
    }
    
    func timeParser(dateString: String) -> Date? {
        let userCalendar = Calendar.current
        
        let range = NSRange(location: 0, length: dateString.count)
        let pattern = "[0-9]{1,2}"
        
        let regex = try! NSRegularExpression(pattern: pattern)
        let regexMatches = regex.matches(in: dateString, options: [], range: range)
        
        if regexMatches.count == 2 {
            var dateComponents = DateComponents()
            
            var range = Range(regexMatches.first!.range, in: dateString)
            dateComponents.hour = Int(dateString[range!])
            
            range = Range(regexMatches.last!.range, in: dateString)
            dateComponents.minute = Int(dateString[range!])
            
            return userCalendar.date(from: dateComponents)
        }
        return nil
    }
    
    func letterToIndex(letter: String) -> Int {
        let letter = String(letter.reversed())
        var index = 0
        
        for (ind, character) in letter.enumerated() {
            index += characterToNum(character: character) * Int(pow(26, Double(ind)))
        }
        return (index - 1)
    }
    
    func getLocations(of cabinet: String?, and campus: String?, context: NSManagedObjectContext) -> [Location]? {
        var locations = [Location]()
        
        var campuses = [String]()
        var cabinets = [String]()
        
        let pattern = "[0-9а-яА-Я.]{1,}"
        let regex = try! NSRegularExpression(pattern: pattern)
        
        if cabinet != nil {
            let range = NSRange(location: 0, length: cabinet!.count)
            
            let regexMatches = regex.matches(in: cabinet!, options: [], range: range)
            for cab in regexMatches {
                let rangeG = Range(cab.range, in: cabinet!)
                cabinets.append(String(cabinet![rangeG!]))
            }
        }
        
        if campus != nil {
            let range = NSRange(location: 0, length: campus!.count)
            
            let regexMatches = regex.matches(in: campus!, options: [], range: range)
            for camp in regexMatches {
                let rangeG = Range(camp.range, in: campus!)
                campuses.append(String(campus![rangeG!]))
            }
        }
        
        switch (cabinets.count, campuses.count) {
        case (1, 1):
            let location = Location(context: context)
            location.cabinet = cabinets.first
            location.campus = campuses.first
            
            locations.append(location)
        case (1, 2...):
            for campus in campuses {
                let location = Location(context: context)
                location.cabinet = cabinets.first
                location.campus = campus
                
                locations.append(location)
            }
        case (2..., 1):
            for cabinet in cabinets {
                let location = Location(context: context)
                location.cabinet = cabinet
                location.campus = campuses.first
                
                locations.append(location)
            }
        case (2, 2):
            let firstLocation = Location(context: context)
            firstLocation.cabinet = cabinets.first
            firstLocation.campus = cabinets.last
            
            locations.append(firstLocation)
            
            let secondLocation = Location(context: context)
            secondLocation.cabinet = campuses.first
            secondLocation.campus = campuses.last
            
            locations.append(secondLocation)
        case (1... , 0):
            var buf = ""
            for (index, cabinet) in cabinets.enumerated() {
                if index % 2 != 0 {
                    let location = Location(context: context)
                    location.cabinet = buf
                    location.campus = cabinet
                    
                    locations.append(location)
                }
                else {
                    buf = cabinet
                }
            }
        case (0, 1...):
            var buf = ""
            for (index, campus) in campuses.enumerated() {
                if index % 2 != 0 {
                    let location = Location(context: context)
                    location.cabinet = buf
                    location.campus = campus
                    
                    locations.append(location)
                }
                else {
                    buf = campus
                }
            }
        case (0,0):
            break
        default:
            print("ERROR: getLocations, unknown option")
        }
        return locations
    }
    
    func characterToNum(character: Character) -> Int {
        switch character {
        case "A": return 1
        case "B": return 2
        case "C": return 3
        case "D": return 4
        case "E": return 5
        case "F": return 6
        case "G": return 7
        case "H": return 8
        case "I": return 9
        case "J": return 10
        case "K": return 11
        case "L": return 12
        case "M": return 13
        case "N": return 14
        case "O": return 15
        case "P": return 16
        case "Q": return 17
        case "R": return 18
        case "S": return 19
        case "T": return 20
        case "U": return 21
        case "V": return 22
        case "W": return 23
        case "X": return 24
        case "Y": return 25
        case "Z": return 26
        default:
            print ("ERROR")
            return 0
        }
    }
    
}
