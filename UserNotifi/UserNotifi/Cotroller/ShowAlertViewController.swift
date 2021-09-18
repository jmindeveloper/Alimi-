//
//  ShowAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

class ShowAlertViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertList = [Alert]()
    var naviTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = naviTitle
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func addAlertButton(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.sendAlertDataClosure = { alert in
            Alert.alerts.append(alert)
            
            if ListAlertViewController.dateArray.contains(alert.dateFormatter) != true {
                ListAlertViewController.dateArray.append(alert.dateFormatter)
                ListAlertViewController.dateDictionary[alert.dateFormatter] = [alert]
            } else {
                ListAlertViewController.dateDictionary[alert.dateFormatter]?.append(alert)
            }
            
            if ListAlertViewController.categoryArray.contains(alert.category) != true {
                ListAlertViewController.categoryArray.append(alert.category)
                ListAlertViewController.categoryDictionary[alert.category] = [alert]
            } else {
                ListAlertViewController.categoryDictionary[alert.category]?.append(alert)
            }
            
            self.alertList.append(alert)
            
            self.tableView.reloadData()
            
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
        
    }
    
}

extension ShowAlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell else { return UITableViewCell() }
        
        cell.titleLabel.text = alertList[indexPath.row].title
        cell.timeLabel.text = "\(alertList[indexPath.row].meridiemFormatter) \(alertList[indexPath.row].timeFormatter)"
        cell.dateLabel.text = alertList[indexPath.row].dateFormatter
        if alertList[indexPath.row].repeatNoti == true {
            cell.repeatLabel.isHidden = false
            cell.repeatLabel.text = alertList[indexPath.row].repeatCycleFormatter
        } else {
            cell.repeatLabel.isHidden = true
        }

        return cell
        
    }
    
}

extension ShowAlertViewController: UITableViewDelegate {
    
    // 메모보기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") as? MemoViewController else { return }
        memoVC.memo = Alert.alerts[indexPath.row].memo
        memoVC.naviTitle = Alert.alerts[indexPath.row].title
        
        self.present(memoVC, animated: true, completion: nil)
    }
    
}

class Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var repeatLabel: UILabel!
    
}

class CycleCell: UITableViewCell {
    
}
