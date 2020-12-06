//
//  SettingsViewController.swift
//  TimeTable
//
//  Created by ar_ko on 03/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    var viewModel: SettingsViewModel!
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCourseLabel: UILabel!
    @IBOutlet weak var clearCacheButton: UIButton!
    
    
    static func instantiate() -> SettingsViewController {
        let storyboadr = UIStoryboard(name: "SettingsStoryboard", bundle: .main)
        let controller = storyboadr.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupProfileLabel.text = viewModel.groupProfile
        groupCourseLabel.text = viewModel.groupCourse
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tappedButton(withIndexPath: indexPath)
    }
}
