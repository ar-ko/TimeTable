//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


/*let firstGroup = Group(name: "Экономика и управление", curse: "1", semestrDate: "27.01.20-04.04.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "B", startRow: 11, endColumn: "E", endRow: 175)
 let secondGroup = Group(name: "Сервис мехатронных систем", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "N", startRow: 11, endColumn: "Q", endRow: 175)
 let thirdGroup = Group(name: "Правоведение и правоохранительная деятельность", curse: "3", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "AD", startRow: 11, endColumn: "AG", endRow: 175)
 let fourthGroup = Group(name: "Экономика и управление", curse: "2", semestrDate: "03.02.20-06.06.20", practiceDate: nil, sheetId: "%D0%BF%D1%80%D0%BE%D1%84%D1%8B", startColumn: "R", startRow: 11, endColumn: "U", endRow: 175)*/


class TimeTableViewController: UIViewController {
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groupSchedule: GroupSchedule?
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    
    let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove()
        check()
        
        groupSchedule = GroupSchedule(context: context)
        groupSchedule!.group = createGroup(context: context)
        //load()
        
        timeTableView.refreshControl = timeTableRefreshControl
        getTimeTable(context: context)
    }
    
    func remove() {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        
        do {
            let groupSchedule = try context.fetch(fetchRequest)
            
            print("remove \(groupSchedule.count)")
            
            for g in groupSchedule {
                context.delete(g)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func check() {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        
        do {
            let groupSchedule = try context.fetch(fetchRequest)
            
            print("check \(groupSchedule.count)")
        } catch {
            print(error)
        }
    }
    
    func createGroup(context: NSManagedObjectContext) -> Group {
        let group = Group(context: context)
        
        group.name = "Экономика и управление"
        group.curse = "1"
        group.sheetId = "%D0%BF%D1%80%D0%BE%D1%84%D1%8B"
        group.startColumn = "B"
        group.startRow = 11
        group.endColumn = "E"
        group.endRow = 175
        
        return group
    }
    
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastUpdateCell", for: indexPath) as! LastUpdateCell
            
            let groupSchedule = self.groupSchedule
            cell.configure(with: groupSchedule!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
            
            if self.groupSchedule!.timeTable.count > 0 {
                let day = self.groupSchedule!.timeTable[groupSchedule!.indexOfSelectedDay] as! Day
                let lesson = day.lessons![indexPath.row - 1] as! Lesson
                cell.configure(with: lesson)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var day: Day?
        if groupSchedule!.timeTable.count > 0 {
            day = groupSchedule!.timeTable[groupSchedule!.indexOfSelectedDay] as? Day
        }
        return groupSchedule!.timeTable.count > 0 ? day!.lessons!.count + 1 : 0
    }
}

extension TimeTableViewController {
    // MARK: loading TimeTable
    func getTimeTable(context: NSManagedObjectContext) {
        DispatchQueue.main.async {
            TimeTableNetworkService.getTimeTable(group: self.groupSchedule!.group, context: context) { (response) in
                if let response = response {
                    print("tyt")
                    let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
                    do {
                        let groupSchedules = try self.context.fetch(fetchRequest)
                        print(groupSchedules.count)
                        
                        if groupSchedules.count > 0 {
                            groupSchedules.first!.timeTable = NSOrderedSet(array: response.timeTable)
                            groupSchedules.first!.lastUpdate = Date()
                            
                            do {
                                try context.save()
                                print("GroupSchedule saved!")
                            } catch {
                                print(error)
                            }
                            
                        }
                        print("GroupSchedule get!")
                    } catch {
                        print(error)
                    }
                    
                    self.dayTitle.text = self.groupSchedule!.dayTitle
                    self.timeTableView.reloadData()
                }
                else {
                    print("load from cash")
                    self.load()
                }
            }
        }
    }
    
    func load() {
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let groupSchedules = try self.context.fetch(fetchRequest)
            print(groupSchedules.count)
            if groupSchedules.count > 0 {
                self.groupSchedule!.timeTable = groupSchedules.first!.timeTable
                self.groupSchedule!.lastUpdate = groupSchedules.first!.lastUpdate
                
            }
            print("GroupSchedule get!")
        } catch {
            print(error)
        }
        self.dayTitle.text = self.groupSchedule!.dayTitle
        self.timeTableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        getTimeTable(context: context)
        
        sender.endRefreshing()
    }
    
    @IBAction func previousDayPressed(_ sender: UIButton) {
        groupSchedule!.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule!.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        groupSchedule!.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule!.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        groupSchedule!.nextDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule!.dayTitle
        self.timeTableView.reloadData()
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        groupSchedule!.nextDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        dayTitle.text = groupSchedule!.dayTitle
        self.timeTableView.reloadData()
    }
}
