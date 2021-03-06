//
//  GnomesListViewController.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

class GnomesListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var gnomesTableView: UITableView!
    
    fileprivate let showGnomeDetailSegueIdentifier = "showGnomeDetail"    
    fileprivate var brastlewark: Brastlewark?
    fileprivate var filteredGnomes = [Gnome]()
    fileprivate var selectedGnome: Gnome?
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var previewingContext: UIViewControllerPreviewing!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gnomesTableView.register(UINib(nibName: "GnomeTableViewCell", bundle: nil), forCellReuseIdentifier: gnomeCellIdentifier)

        configureSearchController()
        
        if (traitCollection.forceTouchCapability == .available) {
            previewingContext = registerForPreviewing(with: self, sourceView: gnomesTableView)
        }
        
        self.title = "Brastlewark!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brastlewark == nil ? loadData() : ()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadData() {
        APILayer.getBrastlewarkData { (object, error) in
            guard error == nil else {
                let alert = UIAlertController.alertWithAcceptButton(message: error?.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let brastlewark = object as? Brastlewark else {
                let alert = UIAlertController.alertWithAcceptButton(message: NSLocalizedString("Could not process Brastlewark data", comment: ""))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.brastlewark = brastlewark
            self.gnomesTableView.reloadData()
        }
    }
    
    fileprivate func configureSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
//            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            gnomesTableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.placeholder = NSLocalizedString("Search Gnomes!", comment: "")
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = [GnomeFilter.all.description, GnomeFilter.haveFriends.description, GnomeFilter.haveProfessions.description, GnomeFilter.centenary.description]
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
    
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = GnomeFilter.all.description) {
        guard let gnomes = brastlewark?.gnomes else {
            return
        }
        
        filteredGnomes = gnomes.filter({( gnome ) -> Bool in
            
            let scopeFlag: Bool
            
            switch scope {
            case GnomeFilter.haveFriends.description:
                scopeFlag = !((gnome.friends?.isEmpty) ?? true)
            case GnomeFilter.haveProfessions.description:
                scopeFlag = !((gnome.professions?.isEmpty) ?? true)
            case GnomeFilter.centenary.description:
                scopeFlag = (gnome.age ?? 0) >= 100
            default:
                scopeFlag = true
            }
            
            if searchBarIsEmpty() {
                return scopeFlag
            } else if let gnomeName = gnome.name {
                return  scopeFlag && gnomeName.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        })
        
        gnomesTableView.reloadData()
    }
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

// MARK: - UISearchBarDelegate

extension GnomesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - UISearchControllerDelegate

extension GnomesListViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        unregisterForPreviewing(withContext: previewingContext)
        previewingContext = searchController.registerForPreviewing(with: self, sourceView: gnomesTableView)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.unregisterForPreviewing(withContext: previewingContext)
        previewingContext = registerForPreviewing(with: self, sourceView: gnomesTableView)
    }
}

// MARK: - UISearchResultsUpdating

extension GnomesListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

// MARK: - UITableViewDataSource

extension GnomesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredGnomes.count : self.brastlewark?.gnomes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gnomeCellIdentifier) as? GnomeTableViewCell,
            let gnome = isFiltering() ? filteredGnomes[indexPath.row] : self.brastlewark?.gnomes?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.fillData(with: gnome)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GnomesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGnome = isFiltering() ? filteredGnomes[indexPath.row] : self.brastlewark?.gnomes?[indexPath.row]
        performSegue(withIdentifier: showGnomeDetailSegueIdentifier, sender: nil)
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension GnomesListViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = gnomesTableView.indexPathForRow(at: location),
            let cell = gnomesTableView.cellForRow(at: indexPath),
            let detailVC = storyboard?.instantiateViewController(withIdentifier: gnomeDetailTableViewControllerStoryboardID) as? GnomeDetailTableViewController
            else { return nil }
        
        selectedGnome = isFiltering() ? filteredGnomes[indexPath.row] : self.brastlewark?.gnomes?[indexPath.row]
        detailVC.gnome = selectedGnome
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)

        previewingContext.sourceRect = cell.frame

        return detailVC
    }
}
