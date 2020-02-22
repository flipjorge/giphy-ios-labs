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
    //MARK: Tags
    @IBOutlet weak var tagsTextField: UITextField!
    
    var tags:String
    {
        return tagsTextField?.text ?? ""
    }
}
