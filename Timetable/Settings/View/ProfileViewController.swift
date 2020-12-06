//
//  ProfileViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    var viewModel: ProfileViewModel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    static func instantiate() -> ProfileViewController {
        let storyboadr = UIStoryboard(name: "SettingsStoryboard", bundle: .main)
        let controller = storyboadr.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.searchController.view.removeFromSuperview()
        viewModel.viewDidDisappear()
    }
    
    deinit {
        print("ProfileViewController deinit")
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
        cell.textLabel?.text = viewModel.profiles[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profiles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectProfile(index: indexPath.row)
    }
}

extension ProfileViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        viewModel.filterProfilesBySearchText(searchText)
        tableView.reloadData()
    }
    
}
