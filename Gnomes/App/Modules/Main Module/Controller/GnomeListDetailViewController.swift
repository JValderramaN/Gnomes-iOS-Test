//
//  GnomeListDetailViewController.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

class GnomeListDetailViewController: UIViewController {
    
    @IBOutlet weak var listDataTableView: UITableView!
    let showGnomeDetailSegueIdentifier = "showGnomeDetail"
    var gnomeListDetail: GnomeListDetail!
    var gnomeListData: [String]?
    var selectedGnome: Gnome?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = gnomeListDetail == .friends ? "Friends" : "Professions"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gnomeDetailTableViewController = segue.destination as? GnomeDetailTableViewController,
            let selectedGnome = selectedGnome else {
                return
        }
        
        gnomeDetailTableViewController.gnome = selectedGnome
    }
}

// MARK: - UITableViewDataSource

extension GnomeListDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gnomeListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell"),
        let gnomeListData = gnomeListData else {
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
        
        selectedGnome = Brastlewark.shared?.gnome(by: gnomeListData?[indexPath.row])
        performSegue(withIdentifier: showGnomeDetailSegueIdentifier, sender: nil)
    }
}
