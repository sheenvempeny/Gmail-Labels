//
//  LabelsViewController.swift
//  gmailLabels
//
//  Created by sheen vempeny on 4/6/19.
//  Copyright © 2019 sheen vempeny. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class LabelsViewController: UITableViewController {

    private var labels: [GTLRGmail_Label] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    func reload(labels:  [GTLRGmail_Label]) {
        self.labels = labels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        cell.textLabel?.text = labels[indexPath.row].name
        return cell
    }

}
