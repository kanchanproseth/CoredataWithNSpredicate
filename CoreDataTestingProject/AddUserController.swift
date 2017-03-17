//
//  AddUserController.swift
//  CoreDataTestingProject
//
//  Created by Cyberk on 3/14/17.
//  Copyright © 2017 Cyberk. All rights reserved.
//

import UIKit

class AddUserController: UIViewController {
    @IBOutlet weak var IdTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    var userEdit: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userEdit != nil{
            loadData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        if let user = userEdit {
            usernameTextfield.text = user.username
            IdTextfield.text = "\(user.id)"
        }
    }

    @IBAction func doneButton(_ sender: Any) {
            var newUser: User!
            
            if userEdit == nil{
                newUser = User(context: context)
            }else {
                newUser = userEdit
            }
            if let username = usernameTextfield.text {
                newUser.username = username
            }
            if let id = IdTextfield.text{
                newUser.id = Int64((id as NSString).intValue)
            }
        
            AppDelegateAccess.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

}
