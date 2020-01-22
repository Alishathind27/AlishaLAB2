//
//  TaskTableViewController.swift
//  Alisha_765497_Lab2
//
//  Created by Alisha Thind on 2020-01-19.
//  Copyright © 2020 Alisha Thind. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet var taskTableViewLabel: UITableView!
    var tasks: [NSManagedObject]?
    var EntityContext: [NSManagedObjectContext]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

    
        cell.textLabel?.text = tasks![indexPath.row].value(forKey: "title") as? String
        cell.detailTextLabel?.text = "\(tasks![indexPath.row].value(forKey: "addeddays")!)"
        cell.backgroundColor = .white
        let n_days = tasks![indexPath.row].value(forKey: "daysneeded") as? Int
        let a_days = tasks![indexPath.row].value(forKey: "addeddays") as? Int
        if n_days == a_days {
            cell.backgroundColor = .gray
        }
        return cell
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let taskTitle = tasks![indexPath.row].value(forKey: "title") as? String
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "title contains %@", taskTitle!)
        fetchReq.returnsObjectsAsFaults = false
        // Delete the row from the data source
        
        let  delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            do{
                let req = try context.fetch(fetchReq)
                for r in req as! [NSManagedObject]{
                    context.delete(r)
                    self.tasks?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            catch{
               print(error)
            }
        
            //saving data
        do{
            try context.save()
            self.loadCoreData()
        }
        catch{
            print(error)
        }
        
        }
        delete.backgroundColor = .green
               
    let  addDays = UIContextualAction(style: .destructive, title: "AddDays") { (action, view, success) in
        do{
            let req = try context.fetch(fetchReq)
            for r in req as! [NSManagedObject]{
            var d = r.value(forKey: "addeddays") as! Int
            d = d+1
            r.setValue(d, forKey: "addeddays")
            }
            
        }
        catch{
            print(error)
             }
                   
        
         //saving the data
        do{
           try context.save()
            self.loadCoreData()
          }
        catch{
             print(error)
        }
        
        
        }
        addDays.backgroundColor = .black
        return UISwipeActionsConfiguration(actions:[delete,addDays])
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "title contains[c] %@" , searchText)
            
            do{
                let result = try context.fetch(fetchReq)
                tasks = result as! [NSManagedObject]
                print("data search")
            }
            catch{
               print(error)
               
            }
               tableView.reloadData()
        if searchText == ""
        {
            loadCoreData()
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ViewController{
            
            if let cell = sender as? UITableViewCell{
                let titleT = tasks![tableView.indexPath(for: cell)!.row].value(forKey: "title") as! String
                destination.titleofVc = titleT
                 destination.new = false
            }
            
            if let btn = sender as? UIBarButtonItem{
                
                destination.new = true
                
            }
            
            
        }
    }
    
    func loadCoreData()
    {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
     
     
     do{
         let result = try context.fetch(fetchReq)
         tasks = result as! [NSManagedObject]
     }
     catch{
        print(error)
        
     }
        
        tableView.reloadData()
     }
    
    override func viewWillAppear(_ animated: Bool) {
       loadCoreData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    loadCoreData()
        
    }

    @IBAction func searchByDate(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let context = appDelegate.persistentContainer.viewContext
                   let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
               fetchReq.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                   
                   do{
                       let result = try context.fetch(fetchReq)
                       tasks = result as! [NSManagedObject]
                   }
                   catch{
                      print(error)
                      
                   }
                      
                      tableView.reloadData()
        
    }
    @IBAction func searchByTitle(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do{
                let result = try context.fetch(fetchReq)
                tasks = result as! [NSManagedObject]
            }
            catch{
               print(error)
               
            }
               
               tableView.reloadData()
        }

    
}
