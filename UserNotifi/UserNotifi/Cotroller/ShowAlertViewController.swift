//
//  ShowAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

class ShowAlertViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var alerts = [Alert]()
    var group = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "미리알림"
        alerts.append(Alert(category: "미리알림", date: Date(), repeatNoti: false, repeatCycle: Date(), dateFormatter: "2021년 9월 11일", timeFormatter: "09:00", meridiemFormatter: "오전", title: "미리알림", memo: "메모"))
        alerts.append(Alert(category: "미리알림", date: Date(), repeatNoti: true, repeatCycle: Date(), dateFormatter: "2021년 9월 12일", timeFormatter: "01:00", meridiemFormatter: "오후", title: "미리알림2", memo: "공부 열심히"))
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func addAlertButton(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.group = group
        addAlertVC.sendAlertDataClosure = { alert in
            self.alerts.append(alert)
            self.tableView.reloadData()
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
        
    }
    
}

extension ShowAlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell else { return UITableViewCell() }
        
        cell.titleLabel.text = alerts[indexPath.row].title
        cell.timeLabel.text = "\(alerts[indexPath.row].meridiemFormatter) \(alerts[indexPath.row].timeFormatter)"
        if alerts[indexPath.row].repeatNoti == true {
            cell.dateLabel.text = "반복함"
        } else {
            cell.dateLabel.text = alerts[indexPath.row].dateFormatter
        }

        return cell
        
    }
    
}

extension ShowAlertViewController: UITableViewDelegate {
    
    // 메모보기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") as? MemoViewController else { return }
        memoVC.memo = alerts[indexPath.row].memo
        memoVC.naviTitle = alerts[indexPath.row].title
        
        self.present(memoVC, animated: true, completion: nil)
    }
    
}

class Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
}

class CycleCell: UITableViewCell {
    
}
