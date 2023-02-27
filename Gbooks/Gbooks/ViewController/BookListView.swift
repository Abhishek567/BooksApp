//
//  ViewController.swift
//  Gbooks
//
//  Created by Swaminarayan on 25/02/23.
//

import UIKit

class BookListView: UITableViewController {

    var BooksList : [Items] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var Sindex = 0
    
    private var param : [String: Any] = ["q":"\"\"", "maxResults":40]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let lastDate = UserDefaults.standard.value(forKey: "lastUsed") as? Date ?? Date.now
        let diff = Calendar.current.dateComponents([.hour], from: lastDate, to: Date.now)
        if diff.hour ?? 0 < 24{
            BooksList = getBooks()
        }
        syncData()
    }

    @IBAction func openFavBooks(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavBooksVC") as! FavBooksVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BooksList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.bookDetail = BooksList[indexPath.row].volumeInfo

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BookDetailVC") as! BookDetailVC
        vc.bookDetail = BooksList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (BooksList.count - 5){
            Sindex += 40
            syncData()
        }
    }
    
    func syncData(){
        param["startIndex"] = Sindex
        _ = NetworkManager.shared.getData(url: "https://www.googleapis.com/books/v1/volumes", parameter: param, model:BookBaseModel.self, completion: { [self] data in
            if Sindex == 0{
                BooksList = []
            }
            BooksList.append(contentsOf: data.items ?? [])
            insertBooks(books: data.items ?? [])
        }, failure: { error in
            if error.isResponseValidationError{
               let alert = UIAlertController(title: "Error", message: "There was an error fetching the book data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
            else if error.isSessionTaskError{
                let alert = UIAlertController(title: "Error", message: "No Internet Connection. Pls Check...", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default))
                 self.present(alert, animated: true)
            }
        })
    }
}

