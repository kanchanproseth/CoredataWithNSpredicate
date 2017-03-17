//
//  UserCell.swift
//  CoreDataTestingProject
//
//  Created by Cyberk on 3/14/17.
//  Copyright © 2017 Cyberk. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(user:User){
        id.text = "\(user.id)"
        username.text = user.username   
    }
    
}
