//
//  GnomeListDetailViewController.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

let gnomeListDetailViewControllerStoryboardID = "GnomeListDetailViewController"

/// Class used to show gnome's Professions/Friends
class GnomeListDetailViewController: UIViewController {
    
    @IBOutlet fileprivate weak var listDataTableView: UITableView!
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let showGnomeDetailSegueIdentifier = "showGnomeDetail"
    var gnomeListDetail: GnomeListDetail!
    var gnomeListData: [String]?
    fileprivate var filteredListData = [String]()
    fileprivate var selectedGnome: Gnome?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString(gnomeListDetail == .friends ? "Friends" : "Professions", comment: "")
        configureSearchController()
        
        if (gnomeListDetail == .friends && traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            //            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            listDataTableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchBar.placeholder = NSLocalizedString(
            gnomeListDetail == .friends ? "Search Friend" : "Search Profession", comment: "")
        definesPresentationContext = true
        
        // Setup the Scope Bar
        if gnomeListDetail == .friends {
            searchController.searchBar.scopeButtonTitles = [GnomeFilter.all.description, GnomeFilter.haveFriends.description, GnomeFilter.haveProfessions.description, GnomeFilter.centenary.description]
        }
        
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gnomeDetailTableViewController = segue.destination as? GnomeDetailTableViewController,
            let selectedGnome = selectedGnome else {
                return
        }
        
        gnomeDetailTableViewController.gnome = selectedGnome
    }
    
    // MARK: - Search Functionality
    
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String? = GnomeFilter.all.description) {
        guard let gnomeListData = gnomeListData else {
            return
        }
        
        filteredListData = gnomeListData.filter({( data ) -> Bool in
            
            let scopeFlag: Bool
            let gnome: Gnome?
            
            if gnomeListDetail == .friends {
                gnome = Brastlewark.shared?.gnome(by: data)
                
                switch scope {
                case GnomeFilter.haveFriends.rawValue?:
                    scopeFlag = !((gnome?.friends?.isEmpty) ?? true)
                case GnomeFilter.haveProfessions.rawValue?:
                    scopeFlag = !((gnome?.professions?.isEmpty) ?? true)
                case GnomeFilter.centenary.rawValue?:
                    scopeFlag = (gnome?.age ?? 0) >= 100
                default:
                    scopeFlag = true
                }
                
                if searchBarIsEmpty() {
                    return scopeFlag
                } else if let gnomeName = gnome?.name {
                    return  scopeFlag && gnomeName.lowercased().contains(searchText.lowercased())
                } else {
                    return false
                }
            } else {
                return data.lowercased().contains(searchText.lowercased())
            }
        })
        
        listDataTableView.reloadData()
    }
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

// MARK: - UISearchBar Delegate

extension GnomeListDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - UISearchResultsUpdating Delegate

extension GnomeListDetailViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

// MARK: - UITableViewDataSource

extension GnomeListDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredListData.count : gnomeListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell"),
            let gnomeListData = isFiltering() ? filteredListData : gnomeListData else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = gnomeListData[indexPath.row]
        
        cell.accessoryType = gnomeListDetail == .friends ? .detailDisclosureButton : .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GnomeListDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard gnomeListDetail == .friends else {
            return
        }
        
        selectedGnome = Brastlewark.shared?.gnome(by: isFiltering() ?
            filteredListData[indexPath.row] : gnomeListData?[indexPath.row])
        performSegue(withIdentifier: showGnomeDetailSegueIdentifier, sender: nil)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension GnomeListDetailViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = listDataTableView.indexPathForRow(at: location),
            let cell = listDataTableView.cellForRow(at: indexPath),
            let detailVC = storyboard?.instantiateViewController(withIdentifier: gnomeDetailTableViewControllerStoryboardID) as? GnomeDetailTableViewController else { return nil }
        
        selectedGnome = Brastlewark.shared?.gnome(by: isFiltering() ?
            filteredListData[indexPath.row] : gnomeListData?[indexPath.row])
        detailVC.gnome = selectedGnome
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
}
