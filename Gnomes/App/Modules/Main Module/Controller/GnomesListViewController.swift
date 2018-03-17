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
    
    let showGnomeDetailSegueIdentifier = "showGnomeDetail"
    var brastlewark: Brastlewark?
    var selectedGnome: Gnome?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gnomesTableView.register(UINib(nibName: "GnomeTableViewCell", bundle: nil), forCellReuseIdentifier: gnomeCellIdentifier)
        loadData()
        
        self.title = "GNOMES FROM Brastlewark!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadData() {
        APILayer.getBrastlewarkData { (object, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            guard let brastlewark = object as? Brastlewark else {
                print("Could not cast object to Brastlewark")
                return
            }
            
            self.brastlewark = brastlewark
            Brastlewark.shared = brastlewark
            self.gnomesTableView.reloadData()
        }
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

extension GnomesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brastlewark?.gnomes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gnomeCellIdentifier) as? GnomeTableViewCell,
            let gnome = self.brastlewark?.gnomes?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.fillData(with: gnome)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GnomesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGnome = self.brastlewark?.gnomes?[indexPath.row]
        performSegue(withIdentifier: showGnomeDetailSegueIdentifier, sender: nil)
    }
}
