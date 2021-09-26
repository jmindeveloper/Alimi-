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
        tableView.estimatedRowHeight = 90
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
            print("objectArray --> \(self.objectArray)")
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

extension ShowAlertViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("삭제")
            success(true)
        }
        let flagAction = UIContextualAction(style: .normal, title: "즐겨찾기") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("flag")
            success(true)
        }
        
        deleteAction.image = UIImage(systemName: "xmark.circle.fill")
        flagAction.backgroundColor = .systemYellow
        flagAction.image = UIImage(systemName: "star")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, flagAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "수정") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("수정")
            
            guard let editAlertVC = self.storyboard?.instantiateViewController(identifier: "EditAlertViewController") as? EditAlertViewController else { return }
            
            editAlertVC.alert = self.objectArray[indexPath.section].sectionObject[indexPath.row]
            print("넘겨준값 --> \(self.objectArray[indexPath.section].sectionObject[indexPath.row])")
            
            editAlertVC.sendAlertDataClosure = { alert in
                
                print("되돌려받은값 --> \(alert)")
                
                func setDataOfObjectArray() {
                    for i in 0..<self.objectArray.count {
                        for j in 0..<self.objectArray[i].sectionObject.count {
                            if self.objectArray[i].sectionObject[j].id == alert.id {
                                self.objectArray[i].sectionObject[j] = alert
                            }
                        }
                    }
                }
                
                func deleteDataOfObjectArray() {
                    for i in 0..<self.objectArray.count {
                        for j in 0..<self.objectArray[i].sectionObject.count {
                            print("sectionObjectIndex --> \(self.objectArray[i].sectionObject)")
                            if self.objectArray[i].sectionObject[j].id == alert.id {
                                self.objectArray[i].sectionObject.remove(at: j)
                                break
                            } else {
                                continue
                            }
                        }
                    }
                }
                
                func changeDateOfObjectArray() {
                    deleteDataOfObjectArray()
                    
                    deleteDataOfObjectArray() // objectArray에 alert이랑 동일한 id를 가진 Alert 삭제
                    
                    for i in 0..<self.objectArray.count { // objectArray[].sectionObject == isEmpty일때 해당 objectArray의 index 삭제
                        if self.objectArray[i].sectionObject.isEmpty {
                            self.objectArray.remove(at: i)
                            print("삭제됨")
                            break
                        }
                    }
                    var a = true
                    print(self.objectArray.count)
                    for i in 0..<self.objectArray.count {
                        print("반복")
                        if self.objectArray[i].sectionName == alert.dateFormatter {
                            self.objectArray[i].sectionObject.append(alert)
                            print("기존값에 추가됨")
                            a = true
                            break
                        } else {
                            a = false
                        }
                    }
                    
                    if a == false || self.objectArray.isEmpty {
                        self.objectArray.append(Objects(sectionName: alert.dateFormatter, sectionObject: [alert]))
                        print("새로 추가됨")
                    }
                    self.objectArray = self.objectArray.sorted { $0.sectionName < $1.sectionName }
                }
                
                if self.naviTitle == "오늘" {
                    // 오늘 날짜가 아닐시 remove, 오늘 날짜시 반영 -> reload Data
                    if self.currentDateFormatter.string(from: Date()) == alert.dateFormatter {
                        setDataOfObjectArray()
                    } else {
                        deleteDataOfObjectArray()
                    }
                    self.tableView.reloadData()
                } else if self.naviTitle == "예정" {
                    // 반영 -> reload Data
                    print("예정")
                    
//                    deleteDataOfObjectArray() // objectArray에 alert이랑 동일한 id를 가진 Alert 삭제
//
//                    for i in 0..<self.objectArray.count { // objectArray[].sectionObject == isEmpty일때 해당 objectArray의 index 삭제
//                        if self.objectArray[i].sectionObject.isEmpty {
//                            self.objectArray.remove(at: i)
//                            print("삭제됨")
//                            break
//                        }
//                    }
//                    var a = true
//                    print(self.objectArray.count)
//                    for i in 0..<self.objectArray.count {
//                        print("반복")
//                        if self.objectArray[i].sectionName == alert.dateFormatter {
//                            self.objectArray[i].sectionObject.append(alert)
//                            print("기존값에 추가됨")
//                            a = true
//                            break
//                        } else {
//                            a = false
//                        }
//                    }
//
//                    if a == false || self.objectArray.isEmpty {
//                        self.objectArray.append(Objects(sectionName: alert.dateFormatter, sectionObject: [alert]))
//                        print("새로 추가됨")
//                    }
                    changeDateOfObjectArray()
                    self.tableView.reloadData()
                } else if self.naviTitle == "전체" {
                    // 반영 -> reload Data
                    setDataOfObjectArray()
                    self.tableView.reloadData()
                } else if self.naviTitle == "즐겨찾기" {
                    print("즐겨찾기")
                } else {
                    // naviTitle과 다를시 remove, 같을시 반영 -> reload Data
                    if self.naviTitle == alert.category {
//                        setDataOfObjectArray()
                        
                        changeDateOfObjectArray()
                        
                    } else {
                        deleteDataOfObjectArray()
                    }
                    self.tableView.reloadData()
                }
                
                
                
                var dateBreak = false
                var categoryBreak = false
                
                func deleteDic(dic: [String: [Alert]], arr: [String], key: Dictionary<String, [Alert]>.Keys.Element, alert: Alert, index: Int, editValue: String, ifDate: Bool) -> ([String: [Alert]], [String]) {
                    var dictionary = dic
                    var array = arr
//                    print("\(editValue) dic --> \(dictionary)")
//                    print("\(editValue) arr --> \(array)")
                    dictionary[key]!.remove(at: index)
                    print("삭제후dic --> \(dictionary)")
                    
                    if ifDate == true {
                        if ((dictionary[key]?.isEmpty) == true) {
                            array.removeAll(where: { $0 == key })
                            dictionary[key] = nil
                        }
                    } else {
                        if ((dictionary[key]?.isEmpty) == true) {
                            dictionary[key] = []
                        }
                    }
                    if array.contains(editValue) == false {
                        array.append(editValue)
                        dictionary[editValue] = [alert]
                    } else {
                        dictionary[editValue]?.append(alert)
                    }
                    
//                    print("dictionary --> \(dictionary)")
//                    print("array --> \(array)")
                    
                    return (dictionary, array)
                }
                
                for i in 0..<Alert.alerts.count {
                    if Alert.alerts[i].id == alert.id {
                        Alert.alerts[i] = alert
                        break
                    }
                }
//                print("date //////////////////////")
                for i in Alert.dateDictionary.keys { // i에 dateDictionary의 key값 순서대로 대입
                    for j in 0..<Alert.dateDictionary[i]!.count { // j에 dateDictionary[i] 배열 순서대로 대입
                        if Alert.dateDictionary[i]![j].id  == alert.id { // j번째 index의 id와 alert의 id 가 같으면
                           
                            let a = deleteDic(dic: Alert.dateDictionary, arr: Alert.dateArray, key: i, alert: alert, index: j, editValue: alert.dateFormatter, ifDate: true)
                            Alert.dateDictionary = a.0
                            Alert.dateArray = a.1
                            
                            dateBreak = true
                            break
                        }
                        if dateBreak == true {
                            break
                        }
                    }
                }
//                print("dateDic --> \(Alert.dateDictionary)")
//                print("datearr --> \(Alert.dateArray)")
                print("category  //////////////////////")
                for i in Alert.categoryDictionary.keys {
                    for j in 0..<Alert.categoryDictionary[i]!.count {
                        if Alert.categoryDictionary[i]![j].id == alert.id {
                            if alert.category != self.naviTitle { // 나중에 바꿔야함
                                let a = deleteDic(dic: Alert.categoryDictionary, arr: Alert.categoryArray, key: i, alert: alert, index: j, editValue: alert.category, ifDate: false)
                                
                                Alert.categoryDictionary = a.0
                                Alert.categoryArray = a.1
                            } else {
                                
                            }
                            categoryBreak = true
                            break
                        }
                        if categoryBreak == true {
                            break
                        }
                    }
                }
                print("categoryDic --> \(Alert.categoryDictionary)")
                print("categoryArr --> \(Alert.categoryArray)")
            }
            
            self.present(editAlertVC, animated: true, completion: nil)
            
            
            
            success(true)
        }
        editAction.image = UIImage(systemName: "info.circle")
        return UISwipeActionsConfiguration(actions: [editAction])
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
