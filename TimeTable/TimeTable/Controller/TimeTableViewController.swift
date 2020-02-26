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
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    
    let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var groupSchedule: GroupSchedule?
    //var groupSchedule = GroupSchedule(timeTable: [[Lesson]](), group: firstGroup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remove()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //let groupName = "Экономика и управление"
        
        //let groupScheduleFetch: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        //groupScheduleFetch.predicate = NSPredicate(format: "GroupSchedule.group.name == Экономика и управление")
        
        /*let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {*/
                groupSchedule = GroupSchedule(context: context)
        groupSchedule!.group = createGroup(context: context)
                //groupSchedule =results.first
                /*try context.save()
            } else {
                groupSchedule = GroupSchedule(context: context)
                groupSchedule?.group = createGroup(context: context)
                //groupSchedule?.group.name = groupName
                //groupSchedule?.group.curse = groupCurse
                
                try context.save()
            }
        } catch {
            print("Ошибка выборки \(error)")
        }*/
         
        timeTableView.refreshControl = timeTableRefreshControl
        getTimeTable(context: context)
    }
    
    func remove() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        
        do {
            let groupSchedule = try context.fetch(fetchRequest)
            
            for g in groupSchedule {
                context.delete(g)
            }
            try context.save()
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
        print("TYT1")
        var day: Day?
        if groupSchedule!.timeTable.count > 0 {
            //print(groupSchedule!.timeTable.count)
            day = groupSchedule!.timeTable[groupSchedule!.indexOfSelectedDay - 1] as? Day
        }
        print(day?.lessons?.count as? Int)
        print("TYT2")
        return groupSchedule!.timeTable.count > 0 ? day!.lessons!.count + 1 : 0
    }
}

extension TimeTableViewController {
    
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
    
    func getTimeTable(context: NSManagedObjectContext) {
        TimeTableNetworkService.getTimeTable(group: groupSchedule!.group, context: context) { (response) in
            if let response = response {
                
                //let groupSchedule = GroupSchedule(context: context)
                
                self.groupSchedule!.timeTable = NSOrderedSet(array: response.timeTable)
                self.groupSchedule!.lastUpdate = Date()
                
                do {
                    try context.save()
                    print("GroupSchedule saved!")
                } catch {
                    print(error)
                }
                
                //groupSchedule.group = self.createGroup(context: context)
                
                //self.groupSchedule = groupSchedule
                
                self.dayTitle.text = self.groupSchedule!.dayTitle
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
}
