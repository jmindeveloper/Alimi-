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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "미리알림"
        alerts.append(Alert(category: "미리알림", date: Date(), repeatNoti: false, repeatCycle: Date(), dateFormatter: "2021년 9월 11일", timeFormatter: "09:00", meridiemFormatter: "오전", title: "미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림미리알림", memo: ""))
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
}

extension ShowAlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell else { return UITableViewCell() }
        
        cell.titleLabel.text = alerts[indexPath.row].title
        cell.dateLabel.text = alerts[indexPath.row].dateFormatter
        cell.timeLabel.text = alerts[indexPath.row].timeFormatter

        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
    
}

extension ShowAlertViewController: UITableViewDelegate {
    
}

class Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class CycleCell: UITableViewCell {
    
}
