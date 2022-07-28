//
//  CoreDataHelper.swift
//  StudentApp
//
//  Created by mac on 20/07/22.
//

import Foundation
import UIKit
import CoreData
import SQLite3
class CoreDataHelper{
    static var sharedInstance = CoreDataHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(object: [String:String],img:Data){
        
       
        let student = NSEntityDescription.insertNewObject(forEntityName: "StudentInformation", into: context)as! StudentInformation
        student.name = object["name"]
        student.id = object["id"]
        student.standard = object["standard"]
        student.classTeacher = object["classTeacher"]
        student.totalMarks = object["totalMarks"]
        student.sanskrit = object["sanskrit"]
        student.science = object["science"]
        student.socialScience = object["socialScience"]
        student.hindi = object["hindi"]
        student.maths = object["maths"]
        student.english = object["english"]
        student.img = img
        
        do{
            try context.save()
        }catch{
            print("Error in saving the data",error)
        }
    }
    
    func get() -> [StudentInformation]{
        var student = [StudentInformation]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StudentInformation")
        do{
            student = try context.fetch(fetchRequest)as! [StudentInformation]
        }catch{
            print("Can't Get Data")
        }
        return student
    }
    
    func delete(index:Int) -> [StudentInformation]{
        var student = get()
        context.delete(student[index])
        student.remove(at: index)
        do{
            try context.save()
        }catch{
            print("Error",error)
        }
        return student
    }
    func update(object:[String:String],i:Int,imgData:Data){
        let student = get()
        student[i].name = object["name"]
        student[i].id = object["id"]
        student[i].classTeacher = object["classTeacher"]!
        student[i].standard = object["standard"]
        student[i].totalMarks = object["totalMarks"]!
        student[i].img = imgData
        
        
        do{
            try context.save()
        }catch{
            print("Error in updating",error)
        }
        
    }
}
