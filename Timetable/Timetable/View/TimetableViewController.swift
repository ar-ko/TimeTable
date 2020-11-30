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
    
    private var weekSkrollView = WeekScrollView()
    
    private var coreDataManager = CoreDataManager()
    private var timetableViewModel: TimetableViewModel!
    
    private let timeTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    static func instantiate() -> TimetableViewController {
        let storyboadr = UIStoryboard(name: "TimetableStoryboard", bundle: .main)
        let controller = storyboadr.instantiateViewController(withIdentifier: "TimetableViewController") as! TimetableViewController
        return controller
    }
    
    //MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        setupWeekScrollView()
        
        timetableViewModel.getTimetable(){
            DispatchQueue.main.async {
                self.timetableView.reloadData()
            }
            
        }
        
    }
    
    private func setupWeekScrollView(){
        weekSkrollView.removeFromSuperview()
        weekSkrollView = WeekScrollView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.bounds.size.height ?? 0), width: self.view.bounds.width, height: 60))
        view.addSubview(weekSkrollView)
        
        weekSkrollView.delegate = self
        weekSkrollView.selectedDay = timetableViewModel.indexOfSelectedDay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timetableViewModel = TimetableViewModel(coreDataManager: self.coreDataManager)
        self.tabBarController?.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController {
            tbc.core = self.coreDataManager
        }
        
        timetableView.refreshControl = timeTableRefreshControl
    }
    
    //MARK: - TabBar
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            timetableViewModel.selectDay(.today)
            updateDayTitleAndReloadView()
            weekSkrollView.selectDay(index: timetableViewModel.indexOfSelectedDay)
        }
    }
}

//MARK: - TableView

extension TimetableViewController: UITableViewDelegate {}

extension TimetableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let lastUpdate = timetableViewModel.getLastUpdate(),
               let lessons = timetableViewModel.getDay()?.lessons else { return UITableViewCell() }
        
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
        guard let lessonsCount = timetableViewModel.getDay()?.lessons?.count else { return 0 }
        return lessonsCount + 1
    }
}

//MARK: - User interface

extension TimetableViewController {
    private func updateDayTitleAndReloadView() {
        DispatchQueue.main.async {
            self.navigationItem.title = self.timetableViewModel.dayTitle
            self.timetableView.reloadData()
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        timetableViewModel.getTimetable() {
            self.updateDayTitleAndReloadView()
        }
        sender.endRefreshing()
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        timetableViewModel.selectDay(.previous)
        
        UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
        weekSkrollView.selectDay(index: timetableViewModel.indexOfSelectedDay)
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        timetableViewModel.selectDay(.next)
        
        UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        
        updateDayTitleAndReloadView()
        weekSkrollView.selectDay(index: timetableViewModel.indexOfSelectedDay)
    }
}

//MARK: - WeekSkrollViewDelegate

extension TimetableViewController: WeekSkrollViewDelegate {
    func indexOfSelectedDay(_ dayIndex: Int) {
        if dayIndex > timetableViewModel.indexOfSelectedDay {
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        } else {
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        }
        
        timetableViewModel.selectDay(.forIndex(dayIndex))
        updateDayTitleAndReloadView()
    }
}
