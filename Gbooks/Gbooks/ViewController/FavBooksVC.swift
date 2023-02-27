//
//  FavBooksVC.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import UIKit

class FavBooksVC: UITableViewController {
    
    private var favBooksList : [Items] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favourite Books"
        favBooksList = FavSaver.shared.favBooks
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favBooksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.bookDetail = favBooksList[indexPath.row].volumeInfo
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
