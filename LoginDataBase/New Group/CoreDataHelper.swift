//
//  CoreDataHelper.swift
//  LoginDataBase
//
//  Created by mac on 04/08/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper{
    static var sharedInstance = CoreDataHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(object:[String:String]){
        let data = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)as! Locations
        
        data.id = object["id"] ?? ""
        data.uid = object["uid"] ?? ""
        data.latitude = object["latitude"] ?? ""
        data.longitude = object["longitude"] ?? ""
        data.descriprion = object["descriprion"] ?? ""
        data.loc_id = object["loc_id"] ?? ""
        data.loc_name = object["loc_name"] ?? ""
        data.location_address = object["location_address"] ?? ""
        data.img1 = object["img"] ?? ""
       
        do{
            try context.save()
        }catch{
            print("Error in Saving the Data")
        }
    }
    
    func getData() -> [Locations]{
        var str = [Locations]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Locations")
        do{
            str = try context.fetch(fetchRequest)as! [Locations]
        }catch{
            print("Can't get Data")
        }
        return str
    }
    func deleteData(dataIndex:Int) -> [Locations]{
        var location = getData()
        context.delete(location[dataIndex])
        location.remove(at: dataIndex)
        do{
            try context.save()
        }catch{
            print("Error while Deleting")
        }
        return location
    }
}
