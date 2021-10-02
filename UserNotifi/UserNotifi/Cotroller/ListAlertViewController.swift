//
//  ListAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

class ListAlertViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let currentDateFormatter = DateFormatter()
    let currentMeridiemFormatter = DateFormatter()
    let currentTimeFormatter = DateFormatter()
    
    var lists: [CellList] = [
    CellList(date: "오늘", count: 0, image: "calendar"),
    CellList(date: "예정", count: 0, image: "arrow.clockwise"),
    CellList(date: "전체", count: 0, image: "folder"),
    CellList(date: "즐겨찾기", count: 0, image: "star.fill")
    ]
    
    static var categoryList: [Category] = [
        Category(categoryName: "미리알림", count: 0, image: "list.bullet", imageColor: ".green")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        currentDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        currentMeridiemFormatter.dateFormat = "a"
        currentMeridiemFormatter.locale = Locale(identifier: "ko")
        currentTimeFormatter.dateFormat = "hh:mm"
        
        print(currentTimeFormatter.string(from: Date()))
        
        var count = 0
        var count1 = 0
        var count2 = 0

        for i in Alert.alerts {
            if i.dateFormatter == currentDateFormatter.string(from: Date()) {
                count += 1
                if i.meridiemFormatter > currentMeridiemFormatter.string(from: Date()) {
                    count1 += 1
                } else if i.meridiemFormatter == currentMeridiemFormatter.string(from: Date()) && i.timeFormatter > currentTimeFormatter.string(from: Date()) {
                    count1 += 1
                }
            } else if i.dateFormatter > currentDateFormatter.string(from: Date()) {
                count1 += 1
            }
        }

        for i in 0..<ListAlertViewController.categoryList.count {
            if let _ = Alert.categoryDictionary[ListAlertViewController.categoryList[i].categoryName] {
                ListAlertViewController.categoryList[i].count = Alert.categoryDictionary[ListAlertViewController.categoryList[i].categoryName]?.count ?? 0
            }
        }
        
        for i in Alert.alerts {
            if i.flag == true {
                count2 += 1
            }
        }
        

        lists[0].count = count
        lists[1].count = count1
        lists[2].count = Alert.alerts.count
        lists[3].count = count2
        self.collectionView.reloadData()
    }

    @IBAction func addCategoryBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "새로운 카테고리", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "저장", style: .default) { _ in
            if alert.textFields![0].text != "" {
                ListAlertViewController.categoryList.append(Category(categoryName: alert.textFields![0].text!, count: 0, image: "list.bullet", imageColor: ".green"))
                Alert.categoryArray.append(alert.textFields![0].text!)
                Alert.categoryDictionary[alert.textFields![0].text!] = []

                self.collectionView.reloadData()
            }
        }

        alert.addTextField { textField in
            textField.placeholder = "카테고리 이름"
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
}

extension ListAlertViewController: UICollectionViewDataSource {
    
    // 섹션별 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return lists.count
        } else {
            return ListAlertViewController.categoryList.count
        }
    }
    
    // 섹션별 셀 데이터
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCellSection1 else { return UICollectionViewCell() }
        guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? CollectionViewCellSection2 else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.cellView.layer.cornerRadius = 20
            cell.layer.shadowRadius = 2
            cell.layer.shadowOpacity = 0.3
            cell.layer.masksToBounds = false
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowColor = UIColor.gray.cgColor
            
            let img = UIImage(systemName: "\(lists[indexPath.row].image)")
            
            cell.date.text = lists[indexPath.row].date
            cell.count.text = String(lists[indexPath.row].count)
            cell.image.image = img
        case 1:
            cell2.cellView.layer.cornerRadius = 20
            cell2.layer.shadowRadius = 2
            cell2.layer.shadowOpacity = 0.3
            cell2.layer.masksToBounds = false
            cell2.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell2.layer.shadowColor = UIColor.gray.cgColor
            
            let img2 = UIImage(systemName: "\(ListAlertViewController.categoryList[indexPath.row].image)")
            
            cell2.image.image = img2
            cell2.label.text = ListAlertViewController.categoryList[indexPath.row].categoryName
            cell2.count.text = String(ListAlertViewController.categoryList[indexPath.row].count)
        default:
            break
        }
        
        if indexPath.section == 0 {
            return cell
        } else if indexPath.section == 1 {
            return cell2
        } else {
            return UICollectionViewCell()
        }
    }
    
    // 섹션 수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    // 헤더뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            header.isHidden = true
            return header
        } else if indexPath.section == 1 {
            header.headerLabel.text = "그룹"
            return header
        } else {
            return UICollectionReusableView()
        }
        
    }
    
    // 헤더뷰 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let width: CGFloat = 0
            let height: CGFloat = 0
            return CGSize(width: width, height: height)
        } else if section == 1 {
            let width: CGFloat = collectionView.bounds.width
            let height: CGFloat = 20
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

extension ListAlertViewController: UICollectionViewDelegate {
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let showAlertView = self.storyboard?.instantiateViewController(identifier: "ShowAlertViewController") as? ShowAlertViewController else { return }
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                showAlertView.alertDictionary = [currentDateFormatter.string(from: Date()): Alert.dateDictionary[currentDateFormatter.string(from: Date())] ?? []]
                showAlertView.naviTitle = "오늘"
            } else if indexPath.row == 1 {
                
                var scheduleDateAlertDictionary = [String: [Alert]]()
                var scheduleDateAlertArray = [String]()
                print("alerts --> \(Alert.dateArray)")
                // scheduleDateAlertDictionary
                for i in Alert.dateArray {
                    if currentDateFormatter.string(from: Date()) < i {
                        print("이후날짜 추가됨")
                        if scheduleDateAlertArray.contains(i) == false {
                            scheduleDateAlertArray.append(i)
                            scheduleDateAlertDictionary[i] = Alert.dateDictionary[i]
                        }
                    } else if currentDateFormatter.string(from: Date()) == i {
                        print("날짜같음")
                        for j in Alert.dateDictionary[i]! {
                            print("\(currentMeridiemFormatter.string(from: Date()))  ///  \(j.meridiemFormatter)")
                            if currentMeridiemFormatter.string(from: Date()) < j.meridiemFormatter {
                                print("오후")
                                if scheduleDateAlertArray.contains(i) == false {
                                    scheduleDateAlertArray.append(i)
                                    scheduleDateAlertDictionary[i] = [j]
                                } else {
                                    scheduleDateAlertDictionary[i]?.append(j)
                                }
                            } else if currentTimeFormatter.string(from: Date()) < j.timeFormatter && currentMeridiemFormatter.string(from: Date()) == j.meridiemFormatter {
                                print("시간")
                                print("\(currentTimeFormatter.string(from: Date())) ///  \(j.timeFormatter)")
                                if scheduleDateAlertArray.contains(i) == false {
                                    scheduleDateAlertArray.append(i)
                                    scheduleDateAlertDictionary[i] = [j]
                                } else {
                                    scheduleDateAlertDictionary[i]?.append(j)
                                }
                            }
                        }
                    }
                }
                
                print("scheduleDateAlertArray --> \(scheduleDateAlertArray)")
                print("schduleDateAlertDictionary --> \(scheduleDateAlertDictionary)")
                showAlertView.alertDictionary = scheduleDateAlertDictionary
                showAlertView.naviTitle = "예정"
                
            } else if indexPath.row == 2 {
                showAlertView.alertDictionary = Alert.dateDictionary
                showAlertView.naviTitle = "전체"
            } else if indexPath.row == 3 {
                // Mark: - 즐겨찾기
                showAlertView.naviTitle = "즐겨찾기"
                
                var flagAlertArray = [Alert]()
                var scheduleDateFlagArray = [String]()
                var scheduleDateFlagDictionary = [String: [Alert]]()
                var dateFlagArray = [String]()
                var dateFlagDictionary = [String: [Alert]]()
                
                for i in Alert.alerts {
                    if i.flag == true {
                        flagAlertArray.append(i)
                    }
                }
                
                for i in flagAlertArray {
                    if dateFlagArray.contains(i.dateFormatter) == false {
                        dateFlagArray.append(i.dateFormatter)
                        dateFlagDictionary[i.dateFormatter] = [i]
                    } else {
                        dateFlagDictionary[i.dateFormatter]?.append(i)
                    }
                }
                showAlertView.alertDictionary = dateFlagDictionary
            }

            
        } else if indexPath.section == 1 {
            
            var categoryDateDictionary = [String: [Alert]]()
            var categoryDateArray = [String]()
            
            for i in Alert.categoryDictionary[Alert.categoryArray[indexPath.row]]! {
                if categoryDateArray.contains(i.dateFormatter) == false {
                    categoryDateArray.append(i.dateFormatter)
                    categoryDateDictionary[i.dateFormatter] = [i]
                } else {
                    categoryDateDictionary[i.dateFormatter]?.append(i)
                }
            }
            showAlertView.alertDictionary = categoryDateDictionary
            showAlertView.naviTitle = ListAlertViewController.categoryList[indexPath.row].categoryName
        }
        self.navigationController?.pushViewController(showAlertView, animated: true)
    }
}

extension ListAlertViewController: UICollectionViewDelegateFlowLayout {
    // 컬렉션뷰 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width: CGFloat = (collectionView.bounds.width - (20 * 3)) / 2
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        } else if indexPath.section == 1 {
            let width: CGFloat = (collectionView.bounds.width) - 40
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

class CollectionViewCellSection1: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var count: UILabel!
    
    
}

class CollectionViewCellSection2: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var count: UILabel!
    
}

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
}


