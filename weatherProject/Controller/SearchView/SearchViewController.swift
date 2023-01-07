//
//  SearchViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2022/12/25.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
    }
    
    
    fileprivate func initSearchBar(){
        let controller = SearchController()
        controller.delegate = self
        
        searchController = UISearchController(searchResultsController: controller)
        searchController.searchResultsUpdater = controller
        
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "도시 또는 공항 검색"
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        backgroundView.addSubview(searchBar)
    }
}

extension SearchViewController: SearchResultDelegate {
    func foundResult(mapItem: MKMapItem) {
        let locality = mapItem.placemark.locality ?? " "
        let country = mapItem.placemark.country ?? " "
        let latitude: String = "\(mapItem.placemark.coordinate.latitude)"
        let longitude: String = "\(mapItem.placemark.coordinate.longitude)"
        let mapItemArray: [String] = [locality, country, latitude, longitude]
                
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SearchWeatherViewController") as? SearchWeatherViewController else {return}
        nextVC.locality = locality
        nextVC.country = country
        nextVC.latitude = Double(latitude)!
        nextVC.longitude = Double(latitude)!
        nextVC.mapItemArray = mapItemArray
        
        self.present(nextVC, animated: true)
        
//        NotificationCenter.default.post(name: Notification.Name("addVC"), object: mapItemArray)
        
        // clear search phrase
        searchController.searchBar.text = ""
    }
}
