//
//  ProfileViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class ProfileViewController: UITableViewController {
    
    var firstLaunch: Bool?
    var context: NSManagedObjectContext?
    private var groups: [Group] = []
    private var groupProfiles: [String] = []
    private var filteredProfiles: [String] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = GetGroupsResponse(context: context!).groups
        
        for group in groups {
            if !groupProfiles.contains(group.name) {
                groupProfiles.append(group.name)
            }
        }
        groupProfiles.sort()
        
        configureSearchController()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCurseSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let groupProfile: String
                if isFiltering {
                    groupProfile = filteredProfiles[indexPath.row]
                } else {
                    groupProfile = groupProfiles[indexPath.row]
                }
                
                UserDefaults.standard.set(groupProfile, forKey: "groupProfile")
                
                let destination = segue.destination as! CurseViewController
                
                destination.groups = groups
                destination.context = context
                destination.firstLaunch = firstLaunch
            }
        }
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var groupProfile: String
        
        if isFiltering {
            groupProfile = filteredProfiles[indexPath.row]
        } else {
            groupProfile = groupProfiles[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        cell.textLabel?.text = groupProfile
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredProfiles.count
        }
        return groupProfiles.count
    }
}

extension ProfileViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredProfiles = groupProfiles.filter({ (groupProfile) -> Bool in
            return groupProfile.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
