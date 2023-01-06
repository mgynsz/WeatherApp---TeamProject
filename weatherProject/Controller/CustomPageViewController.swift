//
//  CustomPageViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2022/12/28.
//

import UIKit
import MapKit

class CustomPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var individualPageViewControllerList = [UIViewController]()
    let pageControl = UIPageControl()
    
    // 페이지컨트롤 인디케이터 상세 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIPageControl{
                (view as! UIPageControl).currentPageIndicatorTintColor = .black
                (view as! UIPageControl).pageIndicatorTintColor = .gray
                (view as! UIPageControl).setIndicatorImage(UIImage(systemName: "plus"), forPage: 0)
                (view as! UIPageControl).currentPage = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = nil
        self.dataSource = self
        self.delegate = self
        
        weatherCard()
        addNotiObserver()
        delNotiObserver()
    }
    
    // 현재 날씨 카드
    func weatherCard() {
        individualPageViewControllerList.append(AddWeatherCardViewController.getInstance())
        individualPageViewControllerList.append(DefaultPageViewController.getInstance())
        setViewControllers([individualPageViewControllerList[1]], direction: .forward, animated: true, completion: nil)
    }
    
    private func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addVC), name: NSNotification.Name("addVC"), object: nil)
    }
    
    private func delNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(delVC), name: NSNotification.Name("delVC"), object: nil)
    }
    
    @objc func addVC(notification: NSNotification) {
        if let addString = notification.object as? String {
            print(addString)
            individualPageViewControllerList.append(PageDetailViewController.getInstance())
            setViewControllers([individualPageViewControllerList[1]], direction: .forward, animated: true)
        }
    }
    
    @objc func delVC(notification: NSNotification) {
        if let addString = notification.object as? Int {
            print(addString)
            individualPageViewControllerList.remove(at: individualPageViewControllerList.count - 1)
            setViewControllers([individualPageViewControllerList[1]], direction: .forward, animated: true)
        }
    }
}

// MARK: - 페이지컨트롤 인디케이터!!

extension CustomPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentPageViewController = individualPageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = indexOfCurrentPageViewController - 1
        
        if indexOfCurrentPageViewController == 1 {
            return individualPageViewControllerList[0]
        } else if previousIndex < 0 {
            return nil
        } else {
            return individualPageViewControllerList[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentindexOfPageViewController = individualPageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentindexOfPageViewController + 1
        
        if nextIndex == individualPageViewControllerList.count {
            return nil
        } else {
            return individualPageViewControllerList[nextIndex]
        }
    }
}

extension CustomPageViewController {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return individualPageViewControllerList.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension CustomPageViewController: SearchResultDelegate {
    func foundResult(mapItem: MKMapItem) {
        print("이거: \(mapItem.placemark.coordinate.latitude)")
        print("이거: \(mapItem.placemark.coordinate.longitude)")
    }
}
