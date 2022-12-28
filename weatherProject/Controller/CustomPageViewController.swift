//
//  CustomPageViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2022/12/28.
//

import UIKit

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
        
        self.dataSource = self
        self.delegate = self

        weatherCard()
    }
    
    // 현재 날씨 카드
    func weatherCard() {
        individualPageViewControllerList = [
            PageDetailViewController.getInstance(index: 0),
            PageDetailViewController.getInstance(index: 1)
        ]
        setViewControllers([individualPageViewControllerList[1]], direction: .forward, animated: true, completion: nil)

    }
}

// MARK: - 페이지컨트롤 인디케이터!!

extension CustomPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let indexOfCurrentPageViewController =
        individualPageViewControllerList.firstIndex(of: viewController)!
        
        if indexOfCurrentPageViewController == 0 {
            return nil
        } else {
            return individualPageViewControllerList[indexOfCurrentPageViewController - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentindexOfPageViewController =
        individualPageViewControllerList.firstIndex(of: viewController)!
        
        if currentindexOfPageViewController == individualPageViewControllerList.count - 1 {
            return nil
        } else {
            return individualPageViewControllerList[currentindexOfPageViewController + 1]
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
