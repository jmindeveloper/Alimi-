//
//  ShowAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

class ShowAlertViewController: UIViewController {
    
    struct Objects {
        
        var sectionName: String
        var sectionObject: [Alert]
        
        init(sectionName: String, sectionObject: [Alert]) {
            self.sectionName = sectionName
            self.sectionObject = sectionObject
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertDictionary = [String: [Alert]]()
    var naviTitle = ""
    var currentDateFormatter = DateFormatter()
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = naviTitle
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        currentDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        print("alertDictionary --> \(alertDictionary)")
        
        reloadData()
    }
    
    func reloadData() {
        for (key, value) in alertDictionary {
            objectArray.append(Objects(sectionName: key, sectionObject: value))
        }
        objectArray = objectArray.sorted { $0.sectionName < $1.sectionName }
    }
    
    @IBAction func addAlertButton(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.categoryName = self.naviTitle
        
        addAlertVC.sendAlertDataClosure = { alert in
            Alert.alerts.append(alert)
            
            if Alert.dateArray.contains(alert.dateFormatter) != true {
                Alert.dateArray.append(alert.dateFormatter)
                Alert.dateDictionary[alert.dateFormatter] = [alert]
            } else {
                Alert.dateDictionary[alert.dateFormatter]?.append(alert)
            }
            
            if Alert.categoryArray.contains(alert.category) != true {
                Alert.categoryArray.append(alert.category)
                Alert.categoryDictionary[alert.category] = [alert]
            } else {
                Alert.categoryDictionary[alert.category]?.append(alert)
            }
            
            if self.naviTitle == alert.category || self.naviTitle == "전체" || self.naviTitle == "예정" || self.naviTitle == "오늘" && alert.dateFormatter == self.currentDateFormatter.string(from: Date()) {
                if let a: Int = self.objectArray.firstIndex(where: { $0.sectionName == alert.dateFormatter}) {
                    self.objectArray[a].sectionObject.append(alert)
                } else {
                    self.objectArray.append(Objects(sectionName: alert.dateFormatter, sectionObject: [alert]))
                }
            }
            self.objectArray = self.objectArray.sorted { $0.sectionName < $1.sectionName }
            self.tableView.reloadData()
            }
        
        self.present(addAlertVC, animated: true, completion: nil)
        
    }
    
}

extension ShowAlertViewController: UITableViewDataSource {
    
    // 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObject.count
    }
    
    // 셀 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell else { return UITableViewCell() }
        
        let alert = objectArray[indexPath.section].sectionObject[indexPath.row]
        
        cell.titleLabel.text = alert.title
        cell.timeLabel.text = "\(alert.meridiemFormatter) \(alert.timeFormatter)"
        cell.dateLabel.text = alert.dateFormatter
        if alert.repeatNoti == true {
            cell.repeatLabel.isHidden = false
            cell.repeatLabel.text = alert.repeatCycleFormatter
        } else {
            cell.repeatLabel.isHidden = true
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
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
