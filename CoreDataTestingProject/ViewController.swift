//
//  ViewController.swift
//  CoreDataTestingProject
//
//  Created by Cyberk on 3/14/17.
//  Copyright © 2017 Cyberk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,NSFetchedResultsControllerDelegate{
    
    var controllers: NSFetchedResultsController<User>!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "usercell")
        fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchData(){
        let fetchrequest : NSFetchRequest<User> = User.fetchRequest()
        let dateSort = NSSortDescriptor(key: "id", ascending: false)
        fetchrequest.sortDescriptors = [dateSort]
        
        let resultcontroller = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultcontroller.delegate = self
        self.controllers = resultcontroller
        do{
            try controllers.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controllers.sections{
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controllers.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Mycell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        configurecell(cell: Mycell, indexpath: indexPath as NSIndexPath)
        return Mycell
    }
    func configurecell(cell:UserCell, indexpath: NSIndexPath){
        let accessItem = controllers.object(at: indexpath as IndexPath)
        cell.configureCell(user: accessItem)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controllers.fetchedObjects, objs.count > 0{
            let user = objs[indexPath.row]
            performSegue(withIdentifier: "adduser", sender: user)
        }
    }
    
    //Update Data == tableview.reload()---------------------------------------------------------------------------
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //CRUD == insert, Update, Delete, Move------------------------------------------------------------------------
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let updateCell = tableView.cellForRow(at: indexPath) as! UserCell
                configurecell(cell: updateCell, indexpath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adduser" {
            let dest = segue.destination as! AddUserController
            if let users = sender as? User{
                dest.userEdit = users
            }
        }
    }
    
    
    @IBAction func addUser(_ sender: Any) {
        performSegue(withIdentifier: "adduser", sender: nil)
    }
    
    @IBAction func searchFilter(_ sender: Any) {
        performSegue(withIdentifier: "search", sender: nil)
    }


}

