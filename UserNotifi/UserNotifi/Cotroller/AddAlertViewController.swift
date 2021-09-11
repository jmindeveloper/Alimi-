//
//  AddAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/11.
//

import UIKit
import DropDown

class AddAlertViewController: UIViewController {
    
    let dropDown = DropDown()
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.dataSource = ["a", "b", "c"]
        
    }
    
    @IBAction func button(_ sender: Any) {
        dropDown.show()
        dropDown.anchorView = btn
        dropDown.bottomOffset = CGPoint(x:0, y: (dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    
}
