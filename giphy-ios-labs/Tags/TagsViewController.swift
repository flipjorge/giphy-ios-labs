//
//  TagsViewController.swift
//  giphy-ios-labs
//
//  Created by Filipe Jorge on 22/02/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit

class TagsViewController : UIViewController
{
    //MARK: Lifecycle
    override func viewDidLoad() {
        tagsTextField?.text = tags ?? ""
    }
    
    //MARK: Tags
    @IBOutlet weak var tagsTextField: UITextField!
    
    var tags:String?
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tags = tagsTextField?.text
    }
}
