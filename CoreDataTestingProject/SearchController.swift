//
//  SearchController.swift
//  CoreDataTestingProject
//
//  Created by Cyberk on 3/14/17.
//  Copyright © 2017 Cyberk. All rights reserved.
//

import UIKit
import CoreData

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var controllers: NSFetchedResultsController<User>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "usercell")

        fetchData()
        self.hideKeyboardWhenTappedAround()
        searchbar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissvc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension SearchController: NSFetchedResultsControllerDelegate{
    func fetchData(){
        let fetchrequest : NSFetchRequest<User> = User.fetchRequest()
        let idSort = NSSortDescriptor(key: "id", ascending: false)
        fetchrequest.sortDescriptors = [idSort]
        
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
    
    func fetchDataWithNspredicate(_ input:String){
        let request = NSFetchRequest<User>(entityName: "User")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
//        let predicate = NSPredicate(format: "type = %@", usernamePredicateFilter!)
        let dateSort = NSSortDescriptor(key: "id", ascending: false)
       
        request.predicate = NSPredicate(format: "username contains[c] %@", searchbar.text!)
        request.sortDescriptors = [dateSort]
        
        let resultcontroller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultcontroller.delegate = self
        self.controllers = resultcontroller
        do{
            try controllers.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        print(request)
        do {
            let results = try context.fetch(request)
            print(results)
        } catch {
            
        }
        tableView.reloadData()

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
}
extension SearchController: UISearchBarDelegate{
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if let searchtext = searchbar.text{
//            fetchDataWithNspredicate(searchtext)
//        }
//        
//    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchtext = searchbar.text{
            fetchDataWithNspredicate(searchtext)
        }
    }
}


