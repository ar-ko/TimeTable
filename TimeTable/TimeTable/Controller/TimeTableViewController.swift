//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class TimeTableViewController: UIViewController, UITabBarControllerDelegate {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groupSchedule: GroupSchedule?
    var groupProfile: String = ""
    var groupCurse: String = ""
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        groupProfile = UserDefaults.standard.string(forKey: "groupProfile") ?? ""
        groupCurse = UserDefaults.standard.string(forKey: "groupCurse") ?? ""
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile, groupCurse])
        do {
            let result = try self.context.fetch(fetchRequest)
            if result.count > 0 {
                groupSchedule = result.first
            } else {
                groupSchedule = GroupSchedule(context: context)
                groupSchedule?.group = createGroup(context: context)
                groupSchedule?.timeTable = NSOrderedSet(array: [Day]())
                groupSchedule?.lastUpdate = nil
            }
        } catch {
            print(error)
        }
        getTimeTable(context: context)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove()
        
        self.tabBarController?.delegate = self
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let result = try self.context.fetch(fetchRequest)
            print("Расписаний: \(result.count)")
            
        } catch {
            print(error)
            
        }
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            tbc.context = context
        }
        
        timeTableView.refreshControl = timeTableRefreshControl
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            groupSchedule?.indexOfSelectedDay = groupSchedule?.getIndexForToday() ?? groupSchedule!.indexOfSelectedDay
            groupSchedule?.dayTitle = (groupSchedule?.getDayName(currentDayIndex: groupSchedule!.indexOfSelectedDay))!
            updateDayTitleAndReloadView()
        }
    }
    
    func remove() {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            for res in result {
                context.delete(res)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func createGroup(context: NSManagedObjectContext) -> Group {
        let group = Group(context: context)
        
        group.name = "Экономика и управление"
        group.curse = "1 курс"
        group.sheetId = "%D0%BF%D1%80%D0%BE%D1%84%D1%8B"
        group.spreadsheetId = "1CrVXpFRuvS4iq8nvGpd27-CeUcnzsRmbNc9nh2CWcWw"
        
        group.startColumn = "B"
        group.startRow = 11
        group.endColumn = "E"
        group.endRow = 179
        
        group.groupInfoStartColumn = "C"
        group.groupInfoStartRow = 8
        group.groupInfoEndColumn = "D"
        group.groupInfoEndRow = 10
        
        UserDefaults.standard.set("Экономика и управление", forKey: "groupProfile")
        UserDefaults.standard.set("1 курс", forKey: "groupCurse")
        
        return group
    }
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastUpdateCell", for: indexPath) as! LastUpdateCell
            
            if groupSchedule?.lastUpdate != nil {
                cell.configure(with: groupSchedule!)
            }
            
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
        guard groupSchedule != nil else { return 0 }
        if groupSchedule!.timeTable.count > 0 {
            day = groupSchedule!.timeTable[groupSchedule!.indexOfSelectedDay] as? Day
        }
        
        return groupSchedule!.timeTable.count > 0 ? day!.lessons!.count + 1 : 0
    }
}

extension TimeTableViewController {
    
    func getTimeTable(context: NSManagedObjectContext) {
        TimeTableNetworkService.getTimeTable(group: self.groupSchedule!.group, context: context) { (response) in
            if let response = response {
                self.groupSchedule!.timeTable = NSOrderedSet(array: response.timeTable)
                self.groupSchedule!.lastUpdate = Date()
                
                do {
                    try context.save()
                    print("GroupSchedule saved!")
                } catch {
                    print(error)
                }
                self.updateDayTitleAndReloadView()
            }
            else {
                print("load from cash")
                self.updateDayTitleAndReloadView()
            }
        }
    }
    
    func updateDayTitleAndReloadView() {
        DispatchQueue.main.async {
            self.dayTitle.text = self.groupSchedule!.dayTitle
            self.timeTableView.reloadData()
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        getTimeTable(context: context)
        
        sender.endRefreshing()
    }
    
    @IBAction func previousDayPressed(_ sender: UIButton) {
        groupSchedule!.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        groupSchedule!.previousDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        groupSchedule!.nextDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        groupSchedule!.nextDayPressed()
        
        UIView.transition(with: timeTableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
    }
}
