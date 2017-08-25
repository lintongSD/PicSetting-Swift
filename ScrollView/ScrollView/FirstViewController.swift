//
//  FirstViewController.swift
//  ScrollView
//
//  Created by 林_同 on 2017/8/10.
//  Copyright © 2017年 林_同. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        
        let lb = MyLabel()
        lb.frame = CGRect(x: 20, y: 200, width: 400, height:50)
        lb.text = "你好啊，然后呢"
        lb.font = UIFont(name: "Georgia", size: 50)
        
        view.addSubview(lb)
        
        let filters = CIFilter.filterNames(inCategory: kCICategoryBlur)
        for filter in filters {
            print("\(filter) name   ")
            
            let filterrrr = CIFilter(name: filter)
            print("\(String(describing: filterrrr))")
//            let attr = filter.attributes
//            print("\(filter) name   ")
            
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
