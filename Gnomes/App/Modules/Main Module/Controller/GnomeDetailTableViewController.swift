//
//  GnomeDetailTableViewController.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

let gnomeDetailTableViewControllerStoryboardID = "GnomeDetailTableViewController"

/// Class used to show Gnome detail
class GnomeDetailTableViewController: UITableViewController {
    
    fileprivate let showGnomeListDetailSegueIdentifier = "showGnomeListDetailSegueIdentifier"
    fileprivate var gnomeListDetail: GnomeListDetail?
    var gnome: Gnome!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        self.title = gnome.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func determineGnomeListDetail(by indexPath: IndexPath, andPerfomSegue: Bool = true) {
        switch indexPath.row {
        case 7:
            gnomeListDetail = .professions
            andPerfomSegue ? performSegue(withIdentifier: showGnomeListDetailSegueIdentifier, sender: nil) : ()
        case 8:
            gnomeListDetail = .friends
            andPerfomSegue ? performSegue(withIdentifier: showGnomeListDetailSegueIdentifier, sender: nil) : ()
        default:
            gnomeListDetail = nil
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 1:            
            cell.textLabel?.text = NSLocalizedString("ID", comment: "")
            cell.detailTextLabel?.text = "\(gnome.id ?? 0)"
        case 2:
            cell.textLabel?.text = NSLocalizedString("NAME", comment: "")
            cell.detailTextLabel?.text = "\(gnome.name ?? "")"
        case 3:
            cell.textLabel?.text = NSLocalizedString("AGE", comment: "")
            cell.detailTextLabel?.text = "\(gnome.age ?? 0)"
        case 4:
            cell.textLabel?.text = NSLocalizedString("WEIGHT", comment: "")
            cell.detailTextLabel?.text = "\(gnome.weight ?? 0)"
        case 5:
            cell.textLabel?.text = NSLocalizedString("HEIGHT", comment: "")
            cell.detailTextLabel?.text = "\(gnome.height ?? 0)"
        case 6:
            cell.textLabel?.text = NSLocalizedString("HAIR COLOR", comment: "")
            cell.detailTextLabel?.text = "\(gnome.hairColor ?? "")"
        case 7:
            cell.textLabel?.text = NSLocalizedString("PROFESSIONS", comment: "")
            cell.detailTextLabel?.text = "\(gnome.professions?.count ?? 0)"
            cell.accessoryType = .detailDisclosureButton
        case 8:
            cell.textLabel?.text = NSLocalizedString("FRIENDS", comment: "")
            cell.detailTextLabel?.text = "\(gnome.friends?.count ?? 0)"
            cell.accessoryType = .detailDisclosureButton
        default:
            guard let thumbnailCell = tableView.dequeueReusableCell(withIdentifier: thumbnailCellIdentifier, for: indexPath) as? ThumbnailTableViewCell, let gnomeThumbnail = gnome.thumbnail else {
                return cell
            }
            
            thumbnailCell.fillData(with: URL(string: gnomeThumbnail))
            cell = thumbnailCell
        }

        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : tableView.estimatedRowHeight
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        determineGnomeListDetail(by: indexPath)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gnomeListDetailViewController = segue.destination as? GnomeListDetailViewController,
            let gnomeListDetail = gnomeListDetail else {
                return
        }
        
        gnomeListDetailViewController.gnomeListDetail = gnomeListDetail
        gnomeListDetailViewController.gnomeListData = gnomeListDetail == .professions ? gnome.professions : gnome.friends
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension GnomeDetailTableViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        determineGnomeListDetail(by: indexPath, andPerfomSegue: false)
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: gnomeListDetailViewControllerStoryboardID) as? GnomeListDetailViewController,
            let gnomeListDetail = gnomeListDetail else { return nil }
        
        detailVC.gnomeListDetail = gnomeListDetail
        detailVC.gnomeListData = gnomeListDetail == .professions ? gnome.professions : gnome.friends
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
}
