//
//  MemoViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/11.
//

import UIKit

class MemoViewController: UIViewController {
    
    var memo: String = ""
    var naviTitle: String = ""
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoView.layer.cornerRadius = 20
        memoView.layer.shadowRadius = 2
        memoView.layer.shadowOpacity = 0.3
        memoView.layer.masksToBounds = false
        memoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        memoView.layer.shadowColor = UIColor.gray.cgColor
        memoLabel.text = memo
        
        navigationBar.topItem?.title = naviTitle
        
    }
}
