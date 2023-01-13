//
//  RegionViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/08.
//

import UIKit

class RegionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var regionName = ["속초", "북춘천", "철원", "동두천", "파주", "대관령", "춘천", "백령도", "북강릉", "강릉", "동해", "서울", "인천", "원주", "울릉도", "수원","영월","충주", "서산", "울진", "청주", "대전", "추풍령", "안동", "상주", "포항", "군산", "홍천", "태백", "정선군", "제천", "보은", "천안", "보령", "부여", "금산", "세종", "부안", "임실", "정읍", "남원", "장수", "고창군", "영광군", "김해시", "순창군", "북창원", "양산시", "보성군", "강진군", "장흥", "해남", "고흥", "의령군", "대구", "전주", "울산", "창원", "광주", "부산", "통영", "목포", "여수", "흑산도", "완도", "고창", "순천", "홍성", "제주", "고산", "성산", "서귀포", "진주", "강화", "양평", "이천", "인제", "함양군", "광양시", "진도군", "봉화", "영주", "문경", "청송군", "영덕", "의성", "구미", "영천", "경주시", "거창", "합천", "밀양", "산청", "거제", "남해"]
    var regionCode = ["속초":"90", "북춘천":"93", "철원":"95", "동두천":"98", "파주":"99", "대관령":"100", "춘천":"101", "백령도":"102", "북강릉":"104", "강릉":"105", "동해":"106", "서울":"108", "인천":"112", "원주":"114", "울릉도":"115", "수원":"119","영월":"121","충주":"127", "서산":"129", "울진":"130", "청주":"131", "대전":"133", "추풍령":"135", "안동":"136", "상주":"137", "포항":"138", "군산":"140", "홍천":"212", "태백":"216", "정선군":"217", "제천":"221", "보은":"226", "천안":"232", "보령":"235", "부여":"236", "금산":"238", "세종":"239", "부안":"243", "임실":"244", "정읍":"245", "남원":"247", "장수":"248", "고창군":"251", "영광군":"252", "김해시":"253", "순창군":"254", "북창원":"255", "양산시":"257", "보성군":"258", "강진군":"259", "장흥":"260", "해남":"261", "고흥":"262", "의령군":"263", "대구":"143", "전주":"146", "울산":"152", "창원":"155", "광주":"156", "부산":"159", "통영":"162", "목포":"165", "여수":"168", "흑산도":"169", "완도":"170", "고창":"172", "순천":"174", "홍성":"177", "제주":"184", "고산":"185", "성산":"188", "서귀포":"189", "진주":"192", "강화":"201", "양평":"202", "이천":"203", "인제":"211", "함양군":"264", "광양시":"266", "진도군":"268", "봉화":"271", "영주":"272", "문경":"273", "청송군":"276", "영덕":"277", "의성":"278", "구미":"279", "영천":"281", "경주시":"283", "거창":"284", "합천":"285", "밀양":"288", "산청":"289", "거제":"294", "남해":"295"]
    
    var region = "강릉"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //모달의 높이를 중간으로 설정
        if #available(iOS 15.0, *) {
            if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regionName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        regionName.sort()
        return regionName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        region = regionName[row]
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        //지역 정보설정
        var regionList = [region, regionCode[region]!]
        NotificationCenter.default.post(name: Notification.Name("setRegion"), object: regionList)
        self.dismiss(animated: true)
    }
    
}
