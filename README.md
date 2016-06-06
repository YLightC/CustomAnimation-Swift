# CustomAnimation-Swift
SnowView.swift //添加雪花效果
 let cellSource = layer as! CAEmitterLayer //初始化发射源
 let emitterCell = CAEmitterCell() //要发射的内容

//必须有否则初始化发射源会出错新建返回layer,不是 CAEmitterLayer
    override class func layerClass() -> AnyClass {
        print("\(#function)")
        return CAEmitterLayer.self
    }

其他动画效果都采用Core Animation
