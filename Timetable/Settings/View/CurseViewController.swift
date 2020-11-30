//
//  CourseViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class CourseViewController: UITableViewController {
    var coreDataManager: CoreDataManager?
    private var courseViewModel: CourseViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let coreDataManager = coreDataManager else { return }
        self.courseViewModel = CourseViewModel(coreDataManager: coreDataManager)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseViewModel?.groupCourses.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        cell.textLabel?.text = courseViewModel?.groupCourses[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let courseViewModel = courseViewModel else { return }
                
        courseViewModel.selectGroup(index: indexPath.row)
        
        performSegue(withIdentifier: "backToSettingsSegue", sender: nil)
    }
}
