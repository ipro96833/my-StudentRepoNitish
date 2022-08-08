//
//  Locations+CoreDataProperties.swift
//  
//
//  Created by mac on 04/08/22.
//
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var id: String?
    @NSManaged public var uid: String?
    @NSManaged public var loc_id: String?
    @NSManaged public var loc_name: String?
    @NSManaged public var location_address: String?
    @NSManaged public var descriprion: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var img1: String?
    @NSManaged public var img2: String?

}
