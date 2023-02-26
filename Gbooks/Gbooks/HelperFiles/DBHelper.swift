//
//  DBHelper.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import Foundation
import CoreData
import UIKit

func insertBooks(books: [Items]){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookDetail")
    for book in books {
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", book.id ?? ""
        )
        do {
            let dbData = try context.fetch(fetchRequest)
            if dbData.count > 0 {
                if let items = dbData as? [BookDetail] {
                    for item in items {
                        context.delete(item)
                    }
                }
            }
            let newbook = BookDetail(context: context)
            newbook.id = book.id
            newbook.title = book.volumeInfo?.title
            newbook.author = book.volumeInfo?.authors?.joined(separator: ",")

            if let url = book.volumeInfo?.imageLinks?.smallThumbnail {
                if let url = URL(string: url) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                      // Error handling...
                      guard let imageData = data else { return }

                      DispatchQueue.main.async {
                          newbook.thumb = imageData
                      }
                    }.resume()
                  }
            }
            try context.save()
        } catch {error.localizedDescription}
    }
}


func getBooks() -> [Items]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookDetail")
    var books: [Items] = []
    do {
        let dbData = try context.fetch(fetchRequest)
        if dbData.count > 0 {
            if let items = dbData as? [BookDetail] {
                for item in items {
                    var book = Items()
                    book.id = item.id
                    var vinfo = VolumeInfo()
                    vinfo.title = item.title
                    vinfo.authors = item.author?.components(separatedBy: ",")
                    vinfo.offlineImage = item.thumb
                    book.volumeInfo = vinfo
                    books.append(book)
                }
            }
        }
    }catch{
        
    }
    return books
}
