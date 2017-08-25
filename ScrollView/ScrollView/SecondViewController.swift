//
//  SecondViewController.swift
//  ScrollView
//
//  Created by 林_同 on 2017/8/10.
//  Copyright © 2017年 林_同. All rights reserved.
//

import UIKit
import CoreImage

class SecondViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.green
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 300, height: 200))
        let image = UIImage.init(named: "1.gif")
//        imageView.image = self.imageToScaleImage(image: image!, targetSize: CGSize(width: 300, height: 200))
//        imageView.image = self.imageToGray(image: image!)
//        imageView.image =  self.imageToSingleColor(image: image!)
        imageView.image = self.changeImageHue(image: image!)
//        imageView.image = self.addPixellate(image: image!)
//        imageView.addSubview(self.addBlurEffect(image: image!)!)
        view.addSubview(imageView)
        
    }
    
// MARK: 图片缩放
    func imageToScaleImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthScale = targetSize.width / size.width
        let heightScale = targetSize.height / size.height
        
        let targetScale = (widthScale > heightScale) ? heightScale : widthScale
        
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect(x: 0, y: 0, width: targetScale * size.width, height: targetScale * size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage;
    }

// MARK: 转换成灰度图片
    func imageToGray(image: UIImage) -> UIImage? {
        
        let space = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: CGBitmapInfo().rawValue)
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        context?.draw(image.cgImage!, in: rect)
        
        let grayImage = UIImage(cgImage: (context?.makeImage())!)
        
        
        return grayImage
    }
    
// MARK: 转换成单色图片
    func imageToSingleColor(image: UIImage) -> UIImage {
        
        let ciImg = CIImage(image: image)
        let color = CIColor(red: 0.8, green: 0.6, blue: 0.4)
        let filter = CIFilter(name: "CIColorMonochrome")    //初始化滤镜对象，设置为单色调滤镜
        filter?.setValue(color, forKey: kCIInputColorKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)     //滤镜颜色浓度值
        filter?.setValue(ciImg, forKey: kCIInputImageKey)   //设置需要应用的图片
        
        let outImage = filter?.outputImage
        
        
        return UIImage.init(ciImage: outImage!)
    }
    
// MARK: 更改图片色相
    func changeImageHue(image: UIImage) -> UIImage? {
        
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIHueAdjust")
        filter?.setValue(3.14, forKey: kCIInputAngleKey)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        let outputImage = filter?.outputImage
        let newImage = UIImage.init(ciImage: outputImage!)
    
        return newImage
    }
    
// MARK: 添加马赛克
    func addPixellate(image: UIImage) -> UIImage? {
        
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIPixellate")
        
        filter?.setDefaults()
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        let outputImage = filter?.outputImage
        
        let newImage = UIImage.init(ciImage: outputImage!)
        
        
        return newImage
    }
    
// MARK: 毛玻璃效果
    func addBlurEffect(image: UIImage) -> UIView? {
        
        if #available(iOS 8.0, *) {
            let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blureView = UIVisualEffectView(effect: blur)
            blureView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            blureView.layer.cornerRadius = 30
            blureView.layer.masksToBounds = true
            
            return blureView
            
        }else{
            print("不支持毛玻璃API")
        }
        
        return nil
        
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
