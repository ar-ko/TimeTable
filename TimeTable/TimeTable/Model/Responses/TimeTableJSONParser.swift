//
//  TimeTableJSONParser.swift
//  TimeTable
//
//  Created by ar_ko on 03/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


extension GetTimeTableResponse {
    
    func JSONParser(of json:TimeTableJSON, for group: Group) -> [[Lesson]] {
        
        let startColumnIndex = letterToIndex(letter: group.startColumn)
        let startRowIndex = group.startRow - 1
        
        let daysSeparator = getDaysSeparator(json: json, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex))
        print(daysSeparator)
        
        return [[Lesson]]()
    }
    
    func getDaysSeparator(json: TimeTableJSON, rangeIndexes: (startColumnIndex: Int, startRowIndex: Int)) -> [Int] {
        var merges = json.sheets.last!.merges
        
        merges = merges.filter { $0.startColumnIndex == rangeIndexes.startColumnIndex && $0.endColumnIndex == rangeIndexes.startColumnIndex + 1}
        merges.sort { $0.startRowIndex < $1.startRowIndex }
        
        var rowIndex = rangeIndexes.startRowIndex
        var separatorIndex = 0
        var DaysSeparator = [Int]()
        
        for merge in merges {
            if merge.startRowIndex == rowIndex {
                separatorIndex += 4
                rowIndex = merge.endRowIndex
            }
            else {
                DaysSeparator.append((DaysSeparator.last ?? 0) + separatorIndex)
                separatorIndex = 5
                rowIndex = merge.endRowIndex
            }
        }
        return DaysSeparator
    }
    
    func letterToIndex(letter: String) -> Int {
        let letter = String(letter.reversed())
        var index = 0
        
        for (ind, character) in letter.enumerated() {
            index += characterToNum(character: character) * Int(pow(26, Double(ind)))
        }
        return (index - 1)
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
