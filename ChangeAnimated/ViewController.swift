//
//  ViewController.swift
//  ChangeAnimated
//
//  Created by yaosixu on 16/6/6.
//  Copyright © 2016年 Ysx. All rights reserved.
//

import UIKit

//要更改状态栏字体颜色，需要在info.plist文件中增加 View controller-based status bar appearance 字段值为NO
/*
 * if you want to change the status color, you must add "View controller-based status bar appearance" in info.plist,type is bool
 * value is NO
 */


//延时
func delay(seconds: Double, completion: () -> ()) {
    
    print("\(#function)")
    
    let nsTimer = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds ) )
    
    dispatch_after(nsTimer, dispatch_get_main_queue()) {
        completion()
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var InfoLabel: UILabel!
    
    var index = -1
    var snow : SnowView!
    var sunary : SunaryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BGImageView.image = UIImage(named: "bg-snowy")
        InfoLabel.hidden = true
        
        //snow   添加雪花背景
        snow = SnowView(frame: CGRect(x: -150, y: -100, width: 300, height: 50))
        let snowClipView = UIView(frame: view.frame)
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snow)
        view.addSubview(snowClipView)
                
        //sunary  阳光束
//        sunary = SunaryView(frame: CGRect(x: UIScreen.mainScreen().bounds.width - 60, y: 64, width: 50, height: 50))
//        let sunaryView = UIView(frame: view.frame)
//        sunaryView.clipsToBounds = true
//        sunaryView.addSubview(sunary)
//        view.addSubview(sunaryView)
        
        addEffect()
        changeBgImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //增加动画效果
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        leftIn(userIdTextField.layer)
        leftIn(passwordTextField.layer,delayTime: 0.2)
    }
    
    //更换背景图片
    func changeBgImage() {
        switch index {
        case  1:
            BGImageView.image = UIImage(named: "bg-sunny")
            UIApplication.sharedApplication().statusBarStyle = .Default
            snow.hidden = true
            index = -1
        case -1:
            BGImageView.image = UIImage(named: "bg-snowy")
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            snow.hidden = false
            index = 1
            view.layoutIfNeeded()
        default:
            return
        }
        delay(3, completion: { [unowned self] _ in
            self.changeBgImage()
        })
    }
    
    
    //给控件添加效果
    func addEffect() {
        //由于雪花效果添加在最上层，覆盖了两个文本框和按钮。因此利用bringSubviewToFront函数将这三个控件"上移"
        self.view.bringSubviewToFront(userIdTextField)
        self.view.bringSubviewToFront(passwordTextField)
        self.view.bringSubviewToFront(LogInButton)
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
        //给空间添加圆角
        userIdTextField.layer.cornerRadius = 4
        userIdTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 4
        passwordTextField.layer.masksToBounds = true
        LogInButton.layer.cornerRadius = LogInButton.frame.size.height / 2
        LogInButton.layer.masksToBounds = true
        
        //给logInButton添加点击事件
        LogInButton.addTarget(self, action: #selector(ViewController.tapLogInButton), forControlEvents: .TouchUpInside)
    }
    
    
    //点击登陆按钮
    func tapLogInButton() {
        if userIdTextField.text?.characters.count <= 10 {
            shakeLogInButton(LogInButton)
        }
        
        if passwordTextField.text?.characters.count <= 6 || passwordTextField.text?.characters.count > 20 {
            shakeLogInButton(LogInButton)
        }
        
        InfoLabel.hidden = false
        InfoLabel.text = "登陆成功!"
        InfoLabel.textColor = UIColor.redColor()
        logSuccessInfo(InfoLabel.layer)
    }
    
    
    override func animationDidStart(anim: CAAnimation) {
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if let name = anim.valueForKey("name") as? String {
            
            if name == "positionX" {
                let layer = anim.valueForKey("layer") as? CALayer
                anim.setValue(nil, forKey: "layer")
                springEffect(layer)
            }
            
            if name == "info" {
                InfoLabel.hidden = true
            }
            
        }
    }
    
    //登陆成功提示信息
    func logSuccessInfo(layer: CALayer?) {
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.damping = 2.0
        scale.fromValue = 3.5
        scale.toValue = 1.0
        scale.setValue("info", forKey: "name")
        scale.delegate = self
        scale.duration = scale.settlingDuration
        layer?.addAnimation(scale, forKey: nil)
    }
    
    
    //弹簧效果
    func springEffect(layer: CALayer?) {
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.damping = 2.0
        scale.fromValue = 1.2
        scale.toValue = 1.0
        scale.duration = scale.settlingDuration
        layer?.addAnimation(scale, forKey: nil)
    }
    
    //从左边进入viewController
    func leftIn(layer: CALayer, delayTime: Double = 0) {
        let easyInOut = CABasicAnimation(keyPath: "position.x")
        easyInOut.setValue("positionX", forKey: "name")
        easyInOut.fromValue = -LogInButton.center.x
        easyInOut.toValue = LogInButton.center.x
        easyInOut.duration = 1.25
        easyInOut.delegate = self
        
        easyInOut.setValue(layer, forKey: "layer")
        easyInOut.beginTime = CACurrentMediaTime() + delayTime
        layer.addAnimation(easyInOut, forKey: nil)
    }
    
    //登陆按钮摆动
    func shakeLogInButton(logButton:  UIButton) {

        let shakeX = CASpringAnimation(keyPath: "position.x")
        shakeX.damping = 7.5
        shakeX.mass = 5
        shakeX.stiffness = 2000
        shakeX.initialVelocity = 100
        shakeX.fromValue = logButton.layer.position.x
        shakeX.toValue = logButton.layer.position.x + 10
        shakeX.duration = shakeX.settlingDuration
        
        logButton.layer.addAnimation(shakeX, forKey: nil)
    }
    
}


extension ViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        springEffect(textField.layer)
    }
    
}


