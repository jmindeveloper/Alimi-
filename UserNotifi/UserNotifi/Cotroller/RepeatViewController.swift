//
//  RepeatViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/12.
//

import UIKit

class RepeatViewController: UITableViewController {

    let repeatCycle = ["안함", "매시간", "매일", "매주", "매월", "매년"]
    var sendRepeatCycleDataDelegate: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatCycle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
        cell.textLabel?.text = repeatCycle[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let sendRepeatCycleDataDelegate = sendRepeatCycleDataDelegate {
            sendRepeatCycleDataDelegate(repeatCycle[indexPath.row])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}


