//
//  FavSaver.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import Foundation
class FavSaver{
    static let shared = FavSaver()
    var favBooks: [Items] = []
    
    func writeToJson(){
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(favBooks)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent("favBook.json")
                if !FileManager.default.fileExists(atPath: pathWithFilename.absoluteString){
                    let created = FileManager.default.createFile(atPath: pathWithFilename.absoluteString, contents: nil, attributes: nil)
                    if created{
                        print("File created")
                    }
                }
                    try jsonString?.write(to: pathWithFilename,
                                          atomically: true,
                                          encoding: .utf8)
            }
        }catch{
            
        }
    }
    
    func readJson(){
        do{
            let jsonEncoder = JSONEncoder()
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent("favBook.json")
                if !FileManager.default.fileExists(atPath: pathWithFilename.absoluteString){
                    let jsonDecoder = JSONDecoder()
                    let data = try Data(contentsOf: pathWithFilename)
                    let bookData = try jsonDecoder.decode([Items].self, from: data)
                    favBooks = bookData
                }
            }
        }catch{
            
        }
    }
}
