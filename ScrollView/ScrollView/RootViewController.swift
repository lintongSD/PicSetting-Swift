//
//  RootViewController.swift
//  ScrollView
//
//  Created by 林_同 on 2017/8/10.
//  Copyright © 2017年 林_同. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var isPageControlUsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height)
        view.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.gray
        pageControl.addTarget(self, action: #selector(RootViewController.pageControlDidChanged(_:)), for: UIControlEvents.valueChanged)
        
        print(pageControl.frame)
        
        let firstVC = FirstViewController()
        firstVC.view.frame = view.bounds
        firstVC.view.frame.origin.x = view.frame.width
        
        let secondVC = SecondViewController()
        secondVC.view.frame = view.bounds
        secondVC.view.frame.origin.x = 0
        
        scrollView.addSubview(firstVC.view)
        scrollView.addSubview(secondVC.view)
     
        
        self.addChildViewController(secondVC)
        self.addChildViewController(firstVC)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }

    func pageControlDidChanged(_ sender: AnyObject){
        
        let curPage = (CGFloat)(pageControl.currentPage)
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * curPage
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
        isPageControlUsed = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isPageControlUsed) {
            let pageWidth = scrollView.frame.width
            let page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
            pageControl.currentPage = Int(page)            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
