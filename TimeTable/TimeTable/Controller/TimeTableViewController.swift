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
    
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var groupSchedule: GroupSchedule?
    private var groupProfile: String!
    private var groupCurse: String!
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    private let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private let coreDataStorage = CoreDataStorage()
    
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        groupProfile = UserDefaults.standard.string(forKey: "groupProfile") ?? ""
        groupCurse = UserDefaults.standard.string(forKey: "groupCurse") ?? ""
        
        groupSchedule = coreDataStorage.loadGroupScheldule(profile: groupProfile, curse: groupCurse, in: context)
        
        if groupSchedule != nil {
            self.coreDataStorage.getTimeTable(for: self.groupSchedule!, in: self.context) {
                self.updateDayTitleAndReloadView()
            }
        } else {
            performSegue(withIdentifier: "setupGroupSeque", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataStorage.printGroupSchelduesCount(in: context)
        
        self.tabBarController?.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController {
            tbc.context = context
        }
        
        timeTableView.refreshControl = timeTableRefreshControl
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
 
    //MARK: - TabBar
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            groupSchedule?.setValuesForToday()
            updateDayTitleAndReloadView()
        }
    }
}

    //MARK: - TableView

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
        var day: Day!
        guard groupSchedule != nil else { return 0 }
        if groupSchedule!.timeTable.count > 0 {
            day = groupSchedule!.timeTable[groupSchedule!.indexOfSelectedDay] as? Day
        }
        
        return groupSchedule!.timeTable.count > 0 ? day.lessons!.count + 1 : 0
    }
}

    //MARK: - User interface

extension TimeTableViewController {
    
    private func updateDayTitleAndReloadView() {
        self.dayTitle.text = self.groupSchedule?.dayTitle ?? "Расписание"
        self.timeTableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.coreDataStorage.getTimeTable(for: self.groupSchedule!, in: self.context) {
            self.updateDayTitleAndReloadView()
        }
        
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
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setupGroupSeque" {
            let destination = segue.destination as! ProfileViewController
            
            destination.context = context
            destination.firstLaunch = true
        }
    }
    
    @IBAction func cancelActionMain(_ seque: UIStoryboardSegue) {
    }
}
