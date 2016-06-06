//
//  SnowView.swift
//  ChangeAnimated
//
//  Created by yaosixu on 16/6/6.
//  Copyright © 2016年 Ysx. All rights reserved.
//

import UIKit
import QuartzCore


class SnowView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        print("\(#function)")
        let cellSource = layer as! CAEmitterLayer
        print("make cellSource")
        cellSource.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)  //发射源坐标
        cellSource.emitterSize = bounds.size                               //发射源大小
        cellSource.emitterShape = kCAEmitterLayerRectangle    //发射源形状
        
        let emitterCell = CAEmitterCell()
        let image = UIImage(named: "snowflake")?.CGImage
        emitterCell.contents = image
        
        emitterCell.emissionRange = CGFloat(M_PI_2)
        emitterCell.emissionLongitude = CGFloat(-M_PI)
        
        emitterCell.lifetime = 3.5
        emitterCell.lifetimeRange = 4
        
        emitterCell.velocity = 10
        emitterCell.velocityRange = 300
        
        emitterCell.birthRate = 400
        
        emitterCell.color = UIColor.whiteColor().CGColor
       
        emitterCell.yAcceleration = 70
        emitterCell.xAcceleration = 10
        emitterCell.scale = 0.33
        emitterCell.scaleRange = 1.25
        emitterCell.scaleSpeed = -0.25
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.15
        
        cellSource.emitterCells = [emitterCell]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 在init之前调用！why 创建需要的layer类，在本例中为CAEmitterLayer
    override class func layerClass() -> AnyClass {
        print("\(#function)")
        return CAEmitterLayer.self
    }
}
