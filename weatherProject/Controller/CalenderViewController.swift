



import UIKit

class CalenderViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //모달의 높이를 중간으로 설정
        if #available(iOS 15.0, *) {
            if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
            }
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        //날짜 정보 설정
        var date = Int(formatter.string(from: datePicker.date))!
        NotificationCenter.default.post(name: Notification.Name("setDate"), object: date)
        self.dismiss(animated: true)
    }
}
