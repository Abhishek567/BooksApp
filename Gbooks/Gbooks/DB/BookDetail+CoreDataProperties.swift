//
//  BookDetail+CoreDataProperties.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//
//

import Foundation
import CoreData


extension BookDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookDetail> {
        return NSFetchRequest<BookDetail>(entityName: "BookDetail")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var author: String?
    @NSManaged public var thumb: Data?

}

extension BookDetail : Identifiable {

}
