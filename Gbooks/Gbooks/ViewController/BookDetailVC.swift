//
//  BookDetailVC.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import UIKit
import WebKit

class BookDetailVC: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var bookThumb: UIImageView!
  
    @IBOutlet weak var bookDescription: WKWebView!
    var bookDetail : Items?
    private var unfill: UIBarButtonItem?
    private var fill: UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        let isFav = FavSaver.shared.favBooks.contains { e1 in
            e1.id == bookDetail?.id
        }
        bookDetail?.isFav = isFav
        setButton(fav: isFav)
        getDetail()
    }
    
    func setButton(fav: Bool){
        unfill = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favTaped))
         fill = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favTaped))
         // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = fav ? fill : unfill
    }
    
    @objc func favTaped(){
        if bookDetail?.isFav ?? true{
            bookDetail?.isFav = false
            setButton(fav: false)
            FavSaver.shared.favBooks.removeAll { e1 in
                e1.id == bookDetail?.id
            }
        }else {
            bookDetail?.isFav = true
            setButton(fav: true)
            FavSaver.shared.favBooks.append(bookDetail ?? Items())
        }
    }
    
    func loadInfo(detail: Items){
        if let url = URL(string: detail.volumeInfo?.imageLinks?.thumbnail ?? ""){
            bookThumb.sd_setImage(with: url)
        }
        else{
            bookThumb.image = nil
        }
        bookTitle.text = detail.volumeInfo?.title ?? ""
        authors.text = detail.volumeInfo?.authors?.joined(separator: ", ")
        let html = createHtml(fromString: detail.volumeInfo?.description ?? "")
        bookDescription.loadHTMLString(html , baseURL: Bundle.main.bundleURL)
    }
    
    func createHtml(fromString : String) -> String{
        let htmlString = """
        <html ">
        <head>
                <meta charset="utf-8">
                        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'>
                <meta name=\"viewport\" content=\"initial-scale=1.0\" /></head>
            <body>
                <div>
                    \(fromString)
                </div>
            </body>
        </html>
        """
        return htmlString
    }
    
    func getDetail(){
        _ = NetworkManager.shared.getData(url: "https://www.googleapis.com/books/v1/volumes/\(bookDetail?.id ?? "")", parameter: [:], model:Items.self, completion: { data in
            self.loadInfo(detail: data)
        }, failure: { error in
            if error.isSessionTaskError{
                let alert = UIAlertController(title: "Error", message: "No Internet Connection. Pls Check...", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                 self.present(alert, animated: true)
            }
        })
    }
    
}
