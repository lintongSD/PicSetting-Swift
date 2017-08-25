


//
//  MyLabel.swift
//  ScrollView
//
//  Created by 林_同 on 2017/8/10.
//  Copyright © 2017年 林_同. All rights reserved.
//

import UIKit

class MyLabel: UILabel {

    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
//        CGTextDrawingMode(context, CGTextDrawingMode.stroke)
        
        context?.setLineWidth(2)
        context?.setLineJoin(CGLineJoin.round)
        self.textColor = UIColor.white
        
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(CGTextDrawingMode.fill)
        self.textColor = UIColor.blue
        
        super.drawText(in: rect)
        
    }
    
}
