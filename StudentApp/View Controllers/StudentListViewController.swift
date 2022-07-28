//
//  StudentListViewController.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit
import SQLite
class StudentListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,animalPass//DataPass
{
    
    
       //MARK: Variables
    var student = [StudentInformation]()
    var selectedFilter = Selection.idA
    var select = CategorySelection.AZ
    var arrdicAnimal = [[String:String]]()
    //MARK: Outlets
   
    
    @IBOutlet weak var tblViewStudentList: UITableView!
    @IBOutlet weak var btnOutletStudentDetails: UIButton!
    @IBOutlet weak var btnOutletUserOptions: UIButton!
    
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromSql()
        student = CoreDataHelper.sharedInstance.get()
        let savedFilter = UserDefaults.standard.string(forKey: "selectedFilter")
        if savedFilter == "aZ"{
            selectedFilter = .aZ
            student.sort { $0.name! < $1.name! }
        }else if savedFilter == "zA"{
            selectedFilter = .zA
            student.sort { $0.name! > $1.name! }
        }else if savedFilter == "idA"{
            selectedFilter = .idA
            student.sort { $0.id! < $1.id! }
        }else if savedFilter == "idD"{
            selectedFilter = .idD
            student.sort { $0.id! > $1.id! }
        }else if savedFilter == "marksA"{
            selectedFilter = .marksA
            student.sort { $0.totalMarks! < $1.totalMarks! }
        }else if savedFilter == "marksD"{
            selectedFilter = .marksD
            student.sort { $0.totalMarks! > $1.totalMarks! }
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblViewStudentList.reloadData()
    }
    //MARK: Button Actions
    
    @IBAction func btnActionStudentDetails(_ sender: UIButton) {
    }
    
    @IBAction func btnOutletUserOptions(_ sender: UIButton) {
       //     let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectionOrderWiseViewController")as! SelectionOrderWiseViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewViewController")as! NewViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
   //     vc.delegate = self
        vc.selectedFilter = select
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func passingData(option: CategorySelection) {
        switch option{
        case .AZ:
            UserDefaults.standard.set("AZ", forKey: "Select")
        
        case .ZA:
            UserDefaults.standard.set("ZA", forKey: "Select")
        case .Same:
            UserDefaults.standard.set("Same", forKey: "Select")
        }
    }
    //MARK: Functions
    func dataPassing(optionChoosen: Selection) {
        switch optionChoosen{
        case .aZ:
            UserDefaults.standard.set("aZ", forKey: "selectedFilter")
            student.sort { $0.name! < $1.name! }
            self.tblViewStudentList.reloadData()
           
        case .zA:
            UserDefaults.standard.set("zA", forKey: "selectedFilter")
            student.sort { $0.name! > $1.name! }
            self.tblViewStudentList.reloadData()
        case .idA:
            UserDefaults.standard.set("idA", forKey: "selectedFilter")
            student.sort { $0.id! < $1.id! }
            self.tblViewStudentList.reloadData()
        case .idD:
            UserDefaults.standard.set("idD", forKey: "selectedFilter")
            student.sort { $0.id! > $1.id! }
            self.tblViewStudentList.reloadData()
        case .marksA:
            UserDefaults.standard.set("marksA", forKey: "selectedFilter")
            student.sort { $0.totalMarks! < $1.totalMarks! }
            self.tblViewStudentList.reloadData()
        case .marksD:
            UserDefaults.standard.set("marksD", forKey: "selectedFilter")
            student.sort { $0.totalMarks! > $1.totalMarks! }
            self.tblViewStudentList.reloadData()
        }
    }
    //MARK: Function GetData From SQL
    func getDataFromSql(){
    let fileUrl = Bundle.main.url(forResource: "wild_animal", withExtension: "sqlite")
        print(fileUrl!)
        
        do{
            let myData = try Data(contentsOf: fileUrl!)
            print(myData.count)
            let strUrl = fileUrl?.absoluteString
            let db = try Connection(strUrl!)
            
            for row in try db.prepare("SELECT animal_category, symbol_picture , animal_name, scientific_name FROM animal") {
                arrdicAnimal.append(["category":row[0] as! String,"name":row[2] as! String,"sceientificName":row[3]as! String,"image":row[1]as! String])
                var arr:[String] = []
                var arrData:[String] = []
                for data in arrdicAnimal{
//                    if data["category"] == arr{
//                        
//                    }else{
//                        
//                    }
                }
            }
           print(arrdicAnimal)
        }catch{
            print("Error")
        }
        for animalInfo in arrdicAnimal{
            let animalData = animalInfo["category"]
            print(animalData!)
            
            //MARK: Method 1
//
//            for animal in arrTemp{
//                if animalData == animal{
//
//                }else{
//
//                }
                //MARK: Method 2
//                let arr1 = arrdicAnimal.filter({$["category"] == animalData})
//
//                let arr1.isEmpty{}
                
//            }
//
//            print(animalData!)
        }
    }
    //MARK: Tableview Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return student.count
        return arrdicAnimal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! StudentListTableViewCell
      //  cell.student = student[indexPath.row]
//        let name = arrdicAnimal[indexPath.row]["name"]
//        let scientificName = arrdicAnimal[indexPath.row]["sceientificName"]
        let category = arrdicAnimal[indexPath.row]["category"]
        cell.lblName.text = category
//        cell.lblId.text = scientificName
//        cell.lblMarks.text = category
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            student = CoreDataHelper.sharedInstance.delete(index: indexPath.row)
//            self.tblViewStudentList.deleteRows(at: [indexPath], with: .automatic)
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dict = ["name":student[indexPath.row].name,"id":student[indexPath.row].id,"standard":student[indexPath.row].standard,"classTeacher":student[indexPath.row].classTeacher,"totalMarks":student[indexPath.row].totalMarks]
//        let index = indexPath.row
//        let image = student[indexPath.row].img
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateDataViewController")as! UpdateDataViewController
//        vc.dictStudentData = dict
//        vc.i = index
//        vc.imgData = image
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Extensions

