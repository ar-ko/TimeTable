//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class TimeTableViewController: UIViewController {

    @IBOutlet weak var timeTableView: UITableView!
    var timeTable = [[Lesson]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeTableNetworkService.getTimeTable { (response) in
            guard let response = response else { return }
            self.timeTable = response.timeTable
        }
    }
}


extension TimeTableViewController: UITableViewDelegate {}

extension TimeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
