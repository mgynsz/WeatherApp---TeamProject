//
//  RegionViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/08.
//

import UIKit

class RegionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var regionName = ["속초", "북춘천", "철원", "동두천", "파주", "대관령", "춘천", "백령도", "북강릉", "강릉", "동해", "서울", "인천", "원주", "울릉도", "수원","영월","충주", "서산", "울진", "청주", "대전", "추풍령", "안동", "상주", "포항", "군산"]
    var region = ""
    
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
        return regionName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        region = regionName[row]
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        print(region)
        self.dismiss(animated: true)
    }
    
}
