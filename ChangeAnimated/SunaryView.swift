//
//  Sunary.swift
//  ChangeAnimated
//
//  Created by yaosixu on 16/6/6.
//  Copyright © 2016年 Ysx. All rights reserved.
//

import UIKit
import QuartzCore

//绘制图片
func getImage(imageColor: UIColor, imageSize: CGSize)  -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
    imageColor.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

class SunaryView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let emttierSource = layer as! CAEmitterLayer
        emttierSource.emitterPosition = CGPoint(x: bounds.width - 60, y: 0)
        emttierSource.emitterSize = bounds.size
        emttierSource.emitterShape = kCAEmitterLayerRectangle
        
        let emttierCell = CAEmitterCell()
        let imageColor = UIColor ( red: 1.0, green: 0.8863, blue: 0.5569, alpha: 1.0 )
        let size = CGSize(width: 20, height: 200)
        let image = getImage(imageColor, imageSize: size)
        emttierCell.contents = image.CGImage
        
        emttierCell.birthRate = 0.5
        
        emttierCell.lifetime = 2.0
        emttierCell.lifetimeRange = 2.5
        
        emttierCell.scaleSpeed = -0.15
        emttierCell.scaleRange = 0.3
        
        emttierCell.alphaSpeed = -0.15
        emttierCell.alphaRange = 0.35
        
        emttierCell.zAcceleration = -30
        
        emttierCell.emissionRange = CGFloat(M_PI)
        emttierCell.emissionLongitude = CGFloat(-M_PI_2)
        
        emttierCell.color = UIColor.whiteColor().CGColor
        
        emttierSource.emitterCells = [emttierCell]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
}