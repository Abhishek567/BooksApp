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
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var pages: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bookThumb: UIImageView!
  
    @IBOutlet weak var bookDescription: WKWebView!
    var bookDetail : Items?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDetail()
    }
    
    func loadInfo(){
        if let url = URL(string: bookDetail?.volumeInfo?.imageLinks?.thumbnail ?? ""){
            bookThumb.sd_setImage(with: url)
        }
        else{
            bookThumb.image = nil
        }
        bookTitle.text = bookDetail?.volumeInfo?.title ?? ""
        authors.text = bookDetail?.volumeInfo?.authors?.joined(separator: ", ")
        publisher.text = bookDetail?.volumeInfo?.publisher ?? ""
        pages.text = "\(bookDetail?.volumeInfo?.pageCount ?? 0)"
        date.text = bookDetail?.volumeInfo?.publishedDate ?? ""
        let html = createHtml(fromString: bookDetail?.volumeInfo?.description ?? "")
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
        _ = NetworkManager.shared.getData(url: "https://www.googleapis.com/books/v1/volumes/\(bookDetail?.id ?? "")", parameter: [:], model:Items.self, completion: { [self] data in
            bookDetail = data
            loadInfo()
        }, failure: { error in
            
        })
    }
    
}
