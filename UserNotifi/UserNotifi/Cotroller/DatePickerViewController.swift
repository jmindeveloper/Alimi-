//
//  DatePickerViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/12.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    var sendDateStringClosure: ((String, String, String, Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy년 MM월 dd일"
        timeFormatter.locale = Locale(identifier: "ko")
        
        let timeFormatter2 = DateFormatter()
        timeFormatter2.dateFormat = "hh:mm"
        timeFormatter2.locale = Locale(identifier: "ko")
        
        let timeFormatter3 = DateFormatter()
        timeFormatter3.dateFormat = "a"
        timeFormatter3.locale = Locale(identifier: "ko")
        
        if let sendDateStringClosure = sendDateStringClosure {
            sendDateStringClosure(timeFormatter.string(from: datePicker.date), timeFormatter2.string(from: datePicker.date), timeFormatter3.string(from: datePicker.date), datePicker.date)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
