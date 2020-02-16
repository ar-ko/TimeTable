//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


let firstGroup = Group(name: "Экономика и управление", curse: "1", semestrDate: "27.01.20-04.04.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "B", startRow: 11, endColumn: "E", endRow: 175)
let secondGroup = Group(name: "Сервис мехатронных систем", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "N", startRow: 11, endColumn: "Q", endRow: 175)
let thirdGroup = Group(name: "Правоведение и правоохранительная деятельность", curse: "3", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "AD", startRow: 11, endColumn: "AG", endRow: 175)
let fourthGroup = Group(name: "Экономика и управление", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "R", startRow: 11, endColumn: "U", endRow: 175)


class TimeTableViewController: UIViewController {
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    //var container: NSPersistentContainer!
    
    let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var groupSchedule = GroupSchedule(timeTable: [[Lesson]](), group: firstGroup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTableView.refreshControl = timeTableRefreshControl
        
        getTimeTable()
    }
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastUpdateCell", for: indexPath) as! LastUpdateCell
            
            let groupSchedule = self.groupSchedule
            cell.configure(with: groupSchedule)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
            
            if !self.groupSchedule.timeTable.isEmpty {
                let lessons = self.groupSchedule.timeTable[groupSchedule.indexOfSelectedDay][indexPath.row - 1]
                cell.configure(with: lessons)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupSchedule.timeTable.isEmpty ? 0:groupSchedule.timeTable[groupSchedule.indexOfSelectedDay].count + 1
    }
}

extension TimeTableViewController {
    
    @objc private func refresh(sender: UIRefreshControl) {
        getTimeTable()
        
        sender.endRefreshing()
    }
    
    @IBAction func previousDayPressed(_ sender: UIButton) {
        groupSchedule.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        groupSchedule.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        groupSchedule.nextDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
           groupSchedule.nextDayPressed()
           
           UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
           
           dayTitle.text = groupSchedule.dayTitle
           self.timeTableView.reloadData()
       }
    
    func getTimeTable() {
        TimeTableNetworkService.getTimeTable(group: groupSchedule.groupInfo) { (response) in
            if let response = response {
                self.groupSchedule.timeTable = response.timeTable
                self.groupSchedule.lastUpdate = Date()
                
                //self.saveGroupSchedule(groupSchedule: self.groupSchedule)
                
                self.dayTitle.text = self.groupSchedule.dayTitle
                self.timeTableView.reloadData()
            }
            else {/*
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let fetchRequest: NSFetchRequest<CDGroupSchedule> = CDGroupSchedule.fetchRequest()
                    
                    do {
                        let group = try context.fetch(fetchRequest).first!
                        let time = group.value(forKey: "lastUpdate") as! Date
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM d, HH:mm"
                        print ( dateFormatter.string(from: time))
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }*/
            }
        }
    }
    
    func saveGroupSchedule(groupSchedule: GroupSchedule) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CDGroupSchedule", in: context)
        let groupScheduleObject = NSManagedObject(entity: entity!, insertInto: context) as! CDGroupSchedule
        groupScheduleObject.lastUpdate = groupSchedule.lastUpdate
        
        do {
            try context.save()
            print("OK")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
