//
//  ProfileViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class ProfileViewController: UITableViewController {
    var coreDataManager: CoreDataManager?
    var profileViewModel: ProfileViewModel?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let coreDataManager = coreDataManager else { return }
        self.profileViewModel = ProfileViewModel(coreDataManager: coreDataManager)
        
        configureSearchController()
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        cell.textLabel?.text = profileViewModel?.profiles[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileViewModel?.profiles.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profileViewModel = profileViewModel else { return }
                
        profileViewModel.selectProfile(index: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourseSegue" {
            
            let destination = segue.destination as! CourseViewController
            destination.coreDataManager = coreDataManager
        }
    }
}

extension ProfileViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let profileViewModel = profileViewModel,
              let searchText = searchController.searchBar.text else { return }
        
        profileViewModel.filterProfilesBySearchText(searchText)
        tableView.reloadData()
    }
    
}
