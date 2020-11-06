//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class TimetableViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var timetableView: UITableView!
    private var navigationBar: UINavigationBar!
    private var weekSkrollView = WeekScrollView()
    
    private let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var core = CoreDataManager()
    private var model: TimetableViewModel!
    
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        setupSubview()
        
        
        /*groupProfile = UserDefaults.standard.string(forKey: "groupProfile") ?? ""
         groupCurse = UserDefaults.standard.string(forKey: "groupCurse") ?? ""
         
         groupSchedule = CoreDataManager().loadGroupScheldule(profile: groupProfile, curse: groupCurse)
         
         if groupSchedule != nil {
         CoreDataManager().getTimetable(for: self.groupSchedule!) {
         self.updateDayTitleAndReloadView()
         }
         } else {
         performSegue(withIdentifier: "setupGroupSeque", sender: self)
         }
         */
        
        model.getTimetable(){
            self.timetableView.reloadData()
        }
    }
    
    private func setupSubview(){
        weekSkrollView.removeFromSuperview()
        weekSkrollView = WeekScrollView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.bounds.size.height ?? 0), width: self.view.bounds.width, height: 60))
        view.addSubview(weekSkrollView)
        
        weekSkrollView.delegate = self
        weekSkrollView.selectedDay = model.indexOfSelectedDay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = TimetableViewModel(core: self.core)
        self.tabBarController?.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController {
            tbc.core = self.core
        }
        
        timetableView.refreshControl = timeTableRefreshControl
    }
    
    //MARK: - TabBar
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            model.selectDay(.today)
            updateDayTitleAndReloadView()
            weekSkrollView.selectDay(index: model.indexOfSelectedDay)
        }
    }
}

//MARK: - TableView

extension TimetableViewController: UITableViewDelegate {}

extension TimetableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let lastUpdate = model.getLastUpdate(),
               let lessons = model.getDay()?.lessons else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastUpdateCell", for: indexPath) as! LastUpdateCell
            cell.lastUpdateCellViewModel = LastUpdateCellViewModel(from: lastUpdate)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
            cell.configure(from: LessonCellViewModel(from: lessons[indexPath.row - 1] as! Lesson))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let lessonsCount = model.getDay()?.lessons?.count else { return 0 }
        return lessonsCount + 1
        
    }
}

//MARK: - User interface

extension TimetableViewController {
    
    private func updateDayTitleAndReloadView() {
        navigationItem.title = self.model.dayTitle
        self.timetableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        model.getTimetable() {
            self.updateDayTitleAndReloadView()
        }
        sender.endRefreshing()
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        model.selectDay(.previous)
        
        UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
        weekSkrollView.selectDay(index: model.indexOfSelectedDay)
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        model.selectDay(.next)
        
        UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
        weekSkrollView.selectDay(index: model.indexOfSelectedDay)
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setupGroupSeque" {
            let destination = segue.destination as! ProfileViewController
            
            destination.firstLaunch = true
        }
    }
    
    @IBAction func cancelActionMain(_ seque: UIStoryboardSegue) {
    }
}

//MARK: - WeekSkrollViewDelegate

extension TimetableViewController: WeekSkrollViewDelegate {
    func indexOfSelectedDay(_ dayIndex: Int) {
        if dayIndex > model.indexOfSelectedDay {
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        } else {
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        }
        
        model.selectDay(.forIndex(dayIndex))
        updateDayTitleAndReloadView()
    }
}
