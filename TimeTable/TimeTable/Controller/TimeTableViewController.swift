//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


let firstGroup = Group(name: "Экономика и управление", curse: "1", semestrDate: "27.01.20-04.04.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "B", startRow: 11, endColumn: "E", endRow: 175)
let secondGroup = Group(name: "Сервис мехатронных систем", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "N", startRow: 11, endColumn: "Q", endRow: 175)
let thirdGroup = Group(name: "Правоведение и правоохранительная деятельность", curse: "3", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "AD", startRow: 11, endColumn: "AG", endRow: 175)
let fourthGroup = Group(name: "Экономика и управление", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "R", startRow: 11, endColumn: "U", endRow: 175)


class TimeTableViewController: UIViewController {

    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    var groupSchedule = GroupSchedule(timeTable: [[Lesson]](), group: firstGroup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeTableNetworkService.getTimeTable(group: groupSchedule.groupInfo) { (response) in
            guard let response = response else { return }
            self.groupSchedule.timeTable = response.timeTable
            self.dayTitle.text = self.groupSchedule.dayTitle
            self.timeTableView.reloadData()
        }
    }
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
        
        if !self.groupSchedule.timeTable.isEmpty {
            let lessons = self.groupSchedule.timeTable[groupSchedule.indexOfSelectedDay][indexPath.row]
        cell.configure(with: lessons)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupSchedule.timeTable.isEmpty ? 0:groupSchedule.timeTable[groupSchedule.indexOfSelectedDay].count
    }
}

extension TimeTableViewController {
    @IBAction func previousDayPressed(_ sender: UIButton) {
        groupSchedule.previousDayPressed()
        dayTitle.text = groupSchedule.dayTitle
        
        self.timeTableView.reloadData()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        groupSchedule.nextDayPressed()
        dayTitle.text = groupSchedule.dayTitle
        
        self.timeTableView.reloadData()
    }
}

