//
//  AddWeatherCardViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/03.
//

import UIKit

class AddWeatherCardViewController: UIViewController {

    
    @IBOutlet weak var addWeatherCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addWeatherCardView.isUserInteractionEnabled = true
        self.addWeatherCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addWeatherCardViewTapped)))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
    }
    
    @objc func addWeatherCardViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showSearchView2", sender: sender)
    }
    
    static func getInstance() -> AddWeatherCardViewController {

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddWeatherCardViewController") as! AddWeatherCardViewController
        
        return vc
    }
}
