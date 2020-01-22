//
//  ViewController.swift
//  Alisha_765497_Lab2
//
//  Created by Alisha Thind on 2020-01-19.
//  Copyright © 2020 Alisha Thind. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskLabel: UITextField!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var NumDaysLabel: UITextField!
    var titleofVc = ""
    var changeTask: NSManagedObject?
    
    var new = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if !new {reload()}
//        reload()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext
               
             
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "title contains %@", titleofVc)
        fetchReq.returnsObjectsAsFaults = false
        
            do{
                let result = try context.fetch(fetchReq)
                //for i in result as! [NSManagedObject]
                    
                for ob in result as! [NSManagedObject]{
                    changeTask = ob
                    taskLabel.text = ob.value(forKey: "title") as? String
                    NumDaysLabel.text = "\(ob.value(forKey: "daysneeded") as? Int ?? 0)"
                    descLabel.text = ob.value(forKey: "desc") as? String
                }
                
            }
            catch{
               print(error)
               }
    }

   
    @IBAction func saveTask(_ sender: Any) {
        let title = taskLabel.text ?? ""
        let description = descLabel.text ?? ""
        let daysNumber = Int(NumDaysLabel.text ?? "0") ?? 0
        
        
        if title == "" && description == "" {
            
            let alertController = UIAlertController(title:" All field are required ", message: "Need to fill all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController,animated: true,completion: nil)
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             if changeTask != nil
             {
                 changeTask?.setValue(title, forKey: "title")
                 changeTask?.setValue(description, forKey: "desc")
                 changeTask?.setValue(daysNumber, forKey: "daysneeded")
                 
                 do{
                     try context.save()
                 }
                 catch{
                     print(error)
                 }
             }
             if changeTask == nil{
             let context = appDelegate.persistentContainer.viewContext
             
             let UserEntiy = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
             UserEntiy.setValue(title, forKey: "title")
             UserEntiy.setValue(description, forKey: "desc")
             UserEntiy.setValue(daysNumber, forKey: "daysneeded")
             UserEntiy.setValue(NSDate() as! Date, forKey: "date")
             
             do{
                 try context.save()
             }
             catch{
                 print(error)
             }
             }
            
             taskLabel.text = ""
             descLabel.text = ""
             NumDaysLabel.text = ""
        }
        
        
    }
//    func reload(){
//
//        }
  }



