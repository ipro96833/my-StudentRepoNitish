//
//  StudentInformation+CoreDataProperties.swift
//  StudentApp
//
//  Created by mac on 22/07/22.
//
//

import Foundation
import CoreData


extension StudentInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentInformation> {
        return NSFetchRequest<StudentInformation>(entityName: "StudentInformation")
    }

    @NSManaged public var classTeacher: String?
    @NSManaged public var english: String?
    @NSManaged public var hindi: String?
    @NSManaged public var id: String?
    @NSManaged public var maths: String?
    @NSManaged public var name: String?
    @NSManaged public var sanskrit: String?
    @NSManaged public var science: String?
    @NSManaged public var socialScience: String?
    @NSManaged public var standard: String?
    @NSManaged public var totalMarks: String?
    @NSManaged public var img: Data?

}

extension StudentInformation : Identifiable {

}
