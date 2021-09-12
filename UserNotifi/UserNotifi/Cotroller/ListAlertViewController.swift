//
//  ListAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

class ListAlertViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let lists: [CellList] = [
        CellList(date: "오늘", count: 1, image: "calendar"),
        CellList(date: "예정", count: 1, image: "arrow.clockwise"),
        CellList(date: "전체", count: 1, image: "folder"),
        CellList(date: "즐겨찾기", count: 1, image: "star.fill")
    ]
    
    public var categoryList: [Category] = [
        Category(categoryName: "미리알림", count: 1, image: "list.bullet", imageColor: ".green")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addCategoryBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "새로운 카테고리", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "저장", style: .default) { _ in
            if alert.textFields![0].text != "" {
                self.categoryList.append(Category(categoryName: alert.textFields![0].text!, count: 0, image: "list.bullet", imageColor: ".green"))
                
                print("categoryList --> \(self.categoryList.count)")
                
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
            return categoryList.count
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
            
            let img2 = UIImage(systemName: "\(categoryList[indexPath.row].image)")
            
            cell2.image.image = img2
            cell2.label.text = categoryList[indexPath.row].categoryName
            cell2.count.text = String(categoryList[indexPath.row].count)
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
        
        showAlertView.group = categoryList
        
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
