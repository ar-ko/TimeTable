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
    
    var viewModel: TimetableViewModel!
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        setupWeekScrollView()
        
        viewModel.updateTimetable(){
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
        weekSkrollView.selectedDay = viewModel.indexOfSelectedDay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timetableView.refreshControl = timeTableRefreshControl
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            selectDay(.today)
        }
    }
    
    
    private func updateDayTitleAndReloadView() {
        DispatchQueue.main.async {
            self.navigationItem.title = self.viewModel.dayTitle
            self.timetableView.reloadData()
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.updateTimetable() {
            //проверить обновит ли
            self.updateDayTitleAndReloadView()
        }
        sender.endRefreshing()
    }
    
    
    @IBAction func RightSwipe(_ sender: Any) {
        selectDay(.previous)
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        selectDay(.next)
    }
    
    func selectDay(_ dayType: DayType) {
        switch dayType {
        case .next:
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
        case .previous:
            UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
        case .forIndex(let index):
            if index > viewModel.indexOfSelectedDay {
                UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlUp, .allowUserInteraction], animations: nil)
            } else if index < viewModel.indexOfSelectedDay {
                UIView.transition(with: timetableView, duration: 0.5, options: [.curveEaseOut, .transitionCurlDown, .allowUserInteraction], animations: nil)
            }
        case .today:
           break
        }
        
        viewModel.selectDay(dayType)
        weekSkrollView.selectDay(index: viewModel.indexOfSelectedDay)
        updateDayTitleAndReloadView()
    }
}


extension TimetableViewController: UITableViewDelegate {}

extension TimetableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cell(for: indexPath)
        
        switch cellViewModel {
        case .lastUpdate(let lastUpdateCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastUpdateCell", for: indexPath) as! LastUpdateCell
            cell.configure(from: lastUpdateCellViewModel)
            return cell
        case .lesson(let lessonCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LessonCell
            cell.configure(from: lessonCellViewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
}

extension TimetableViewController: WeekSkrollViewDelegate {
    func indexOfSelectedDay(_ dayIndex: Int) {
        selectDay(.forIndex(dayIndex))
    }
}
