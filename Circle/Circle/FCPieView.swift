//
//  FCPieView.swift
//  Circle
//
//  Created by FC on 2019/5/20.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SnapKit

class FCPieView: UIView {

    /// 数据
    var dataItems: [CGFloat]?
    /// 颜色
    var colorItems: Array<Any>?
    /// 引线上面文字
    var upTextItems: Array<Any>?
    /// 引线下面文字
    var downTextItems: Array<Any>?
    /// 动画时间
    var animationTime: CGFloat?
    /// 外环半径
    var pieR: CGFloat?
    /// 环形宽度
    var pieW: CGFloat?
    /// 圆心
    var pieCenter: CGPoint?
    /// 中间文字
    var middleText: String?
//    /// 是否显示示例，默认显示
//    var isShowSample: Bool = true
    
    /// 初始化
    init(frame: CGRect, datas: [CGFloat], colors: Array<Any>, upTexts: Array<Any>, downTexts: Array<Any>, middle: String) {
        super.init(frame: frame)
        backgroundColor = .white
        
        dataItems = datas
        colorItems = colors
        upTextItems = upTexts
        downTextItems = downTexts
        middleText = middle
        
        animationTime = 0.85
        pieR = height * 0.25
        pieW = pieR! - pieR!/6.0
        pieCenter = CGPoint(x: width/2, y: height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FCPieView {
    
    override func draw(_ rect: CGRect) {
        // 数组元素总和
        let max:CGFloat = dataItems!.reduce(0, +)
        // 开始角度
        var startAngle = -Double.pi/2
        
        let butw:CGFloat = (width - CGFloat((dataItems!.count - 1)) * 8) / CGFloat(dataItems!.count)
        
        for i in 0..<dataItems!.count {
            
//            if isShowSample {
//                let but = UIButton(type: .custom)
//                but.frame = CGRect(x: 0 + CGFloat(Int(butw) * i) + CGFloat(8*i), y: 0, width: butw, height: 10)
//                but.backgroundColor = (colorItems?[i] as AnyObject) as? UIColor
//                but.setTitle(upTextItems![i] as? String, for: .normal)
//                but.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//                addSubview(but)
//            }
            
            
            // 第一步：绘制每个占比扇形部分
            let layer = CAShapeLayer()
            layer.fillColor  = UIColor.clear.cgColor
            layer.strokeColor = (colorItems?[i] as AnyObject).cgColor
            layer.lineWidth = pieW!
            self.layer.addSublayer(layer)
            // 结束角度
            let endAngle = dataItems![i]/max * CGFloat((2*CGFloat.pi)) + CGFloat(startAngle)
            // 绘制曲线
            let layerPath = UIBezierPath(arcCenter: pieCenter!, radius: pieR!, startAngle: CGFloat(startAngle), endAngle: endAngle, clockwise: true)
            layer.path = layerPath.cgPath
            
            
            // 第二部：计算折线及小圆点的位置
            // 小圆点圆心
            let minPieCenter: CGPoint?
            // 外层半径
            let picOutR:CGFloat = pieR! + pieW!/2.0 + 10
            
            // 计算已绘制好的扇形 中间点的角度
            let middleAngle:CGFloat = CGFloat(startAngle + (Double(endAngle) - startAngle)/2.0)
            
            // 折线数据
            let line_1_Point: CGPoint?
            // 终点
            let line_2_Point: CGPoint?
            // 1线宽
            let line_1_w:CGFloat = 10
            // 终点距两边的距离
            let lineSpace:CGFloat = 15
            // 短线偏移角度
            var linAngle = (CGFloat.pi/2)/2
            // 固定值美观
            let fixed: CGFloat = 10
            
            // 确定各个点的位置，参考贝塞尔曲线角度判断，分4个区间
            if middleAngle >= -CGFloat.pi/2 && middleAngle <= 0
            {
                // 1 上右
                let angle:CGFloat = 0 - middleAngle
                minPieCenter = CGPoint(x: pieCenter!.x + CGFloat(cosf(Float(angle)) * Float(picOutR)), y: pieCenter!.y - CGFloat(sinf(Float(angle)) * Float(picOutR)))
                
                if angle > -(CGFloat.pi/2)/2 {
                    linAngle = (CGFloat.pi/2)/3
                }
                
                line_1_Point = CGPoint(x: minPieCenter!.x + CGFloat(cosf(Float(linAngle) * Float(line_1_w))) + fixed, y: minPieCenter!.y - CGFloat(sinf(Float(linAngle)) * Float(line_1_w)))
                line_2_Point = CGPoint(x: width - lineSpace, y: line_1_Point!.y)
                
            }else if middleAngle >= 0 && middleAngle <= CGFloat.pi/2 {
                // 4
                minPieCenter = CGPoint(x: pieCenter!.x + CGFloat(cosf(Float(middleAngle)) * Float(picOutR)), y: pieCenter!.y + CGFloat(sinf(Float(middleAngle)) * Float(picOutR)))
                
                if middleAngle > (CGFloat.pi/2)/2 {
                    linAngle = (CGFloat.pi/2)/3
                }
                
                line_1_Point = CGPoint(x: minPieCenter!.x + CGFloat(cosf(Float(linAngle) * Float(line_1_w))) + fixed, y: minPieCenter!.y + CGFloat(sinf(Float(linAngle)) * Float(line_1_w)))
                line_2_Point = CGPoint(x: width - lineSpace, y: line_1_Point!.y)
                
            }else if middleAngle >= CGFloat.pi/2 && middleAngle <= 2*CGFloat.pi/2 {
                // 3
                let angle:CGFloat = CGFloat.pi - middleAngle
                minPieCenter = CGPoint(x: pieCenter!.x - CGFloat(cosf(Float(angle)) * Float(picOutR)), y: pieCenter!.y + CGFloat(sinf(Float(angle)) * Float(picOutR)))
                
                if middleAngle < 3*(CGFloat.pi/2)/2 {
                    linAngle = CGFloat.pi/2/3
                }
                
                line_1_Point = CGPoint(x: minPieCenter!.x - CGFloat(cosf(Float(linAngle) * Float(line_1_w))) - fixed, y: minPieCenter!.y + CGFloat(sinf(Float(linAngle)) * Float(line_1_w)))
                line_2_Point = CGPoint(x: lineSpace, y: line_1_Point!.y)
                
            }else {
                // 2
                let angle:CGFloat = middleAngle - CGFloat.pi
                minPieCenter = CGPoint(x: pieCenter!.x - CGFloat(cosf(Float(angle)) * Float(picOutR)), y: pieCenter!.y - CGFloat(sinf(Float(angle)) * Float(picOutR)))
                
                if middleAngle > 5*(CGFloat.pi/2)/2 {
                    linAngle = CGFloat.pi/2/3
                }
                
                line_1_Point = CGPoint(x: minPieCenter!.x - CGFloat(cosf(Float(linAngle) * Float(line_1_w))) - fixed, y: minPieCenter!.y - CGFloat(sinf(Float(linAngle)) * Float(line_1_w)))
                line_2_Point = CGPoint(x: lineSpace, y: line_1_Point!.y)
            }
            
            
            // 第三步：绘制圆点
            let minLayer = CAShapeLayer()
            minLayer.fillColor = (colorItems?[i] as AnyObject).cgColor
            self.layer.addSublayer(minLayer)
            // 绘制圆点
            let minPath = UIBezierPath(arcCenter: minPieCenter!, radius: 3, startAngle: -CGFloat.pi/2, endAngle: 3*(CGFloat.pi/2), clockwise: true)
            minLayer.path = minPath.cgPath
            
            
            // 第四步：绘制折线
            let lineLayer = CAShapeLayer()
            lineLayer.strokeColor = (colorItems?[i] as AnyObject).cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(lineLayer)
            
            let linePath = UIBezierPath()
            linePath.move(to: minPieCenter!)
            linePath.addLine(to: line_1_Point!)
            linePath.addLine(to: line_2_Point!)
            lineLayer.path = linePath.cgPath
            
            // 设置动画
            let lineAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
            lineAnimation.duration = CFTimeInterval(animationTime!)
            lineAnimation.repeatCount = 1
            lineAnimation.fromValue = 0
            lineAnimation.toValue = 1
            lineAnimation.isRemovedOnCompletion = false
            lineAnimation.fillMode = kCAFillModeForwards
            lineAnimation.timingFunction = CAMediaTimingFunction(name: "easeOut")
            // 折线添加动画
            lineLayer.add(lineAnimation, forKey: nil)
            
            
            
            // 第五步：设置文字
            var upLb: UILabel?
            var downLb: UILabel?
            // 线上的文字
            if i < upTextItems!.count {
                upLb = createLabel(text: upTextItems![i] as! String, endPoint: line_2_Point!, isUpText: true)
            }
            // 线下的文字
            if i < downTextItems!.count {
                downLb = createLabel(text: downTextItems![i] as! String, endPoint: line_2_Point!, isUpText: false)
            }
            
            // 文字显示简单动画
            UIView.animate(withDuration: TimeInterval(animationTime!)) {
                upLb!.alpha = 1
                downLb!.alpha = 1
            }
            
            // 记录上一绘制的曲线的结尾角度 赋值为 下一绘制曲线的开始角度
            startAngle = Double(endAngle);
        }
        
        // 第六步：绘制分割线及中间文字(可选)
        let partitionLayer = CAShapeLayer()
        partitionLayer.fillColor = UIColor.clear.cgColor;
        partitionLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor;
        partitionLayer.lineWidth = pieW! + 30;
        
        let partitionLayerPath = UIBezierPath(arcCenter: pieCenter!, radius: 2, startAngle: -CGFloat.pi/2, endAngle: 3*(CGFloat.pi/2), clockwise: true)
        partitionLayer.path = partitionLayerPath.cgPath
        self.layer.addSublayer(partitionLayer)
        
        if middleText!.count > 1 {
            let middleLb = UILabel()
            middleLb.text = middleText
            middleLb.font = UIFont.boldSystemFont(ofSize: 15)
            middleLb.textAlignment = .center
            middleLb.textColor = .black
            addSubview(middleLb)
            middleLb.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        // 第七步：绘制遮盖在表层的圆，用于做动画，视觉上感觉是各部分扇形在动
        let backLayer = CAShapeLayer()
        backLayer.fillColor = UIColor.clear.cgColor;
        backLayer.strokeColor = backgroundColor!.cgColor;
        backLayer.lineWidth = pieW! + 5;
        
        let backLayerPath = UIBezierPath(arcCenter: pieCenter!, radius: pieR!, startAngle: -CGFloat.pi/2, endAngle: 3*(CGFloat.pi/2), clockwise: true)
        backLayer.path = backLayerPath.cgPath
        
        let animation = CABasicAnimation.init(keyPath: "strokeStart")
        animation.duration = CFTimeInterval(animationTime!)
        animation.repeatCount = 1
        animation.fromValue = 0
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        backLayer.add(animation, forKey: nil)
        self.layer.addSublayer(backLayer)
    }
    
    /// 创建文字
    private func createLabel(text: String, endPoint:CGPoint, isUpText:Bool) -> (UILabel) {
        let lalel = UILabel()
        lalel.font = UIFont.systemFont(ofSize: 12)
        lalel.text = text
        lalel.alpha = 0
        addSubview(lalel)
        
        if endPoint.x > width/2 {
            lalel.textAlignment = .right
        }
        
        if isUpText {
            lalel.textColor = UIColor.red
            // 线上
            lalel.snp.makeConstraints { (make) in
                make.height.equalTo(15)
                make.bottom.equalTo(-(height - endPoint.y))
                
                if endPoint.x > width/2 {
                    make.right.equalTo(-(width - endPoint.x))
                }else {
                    make.left.equalTo(endPoint.x)
                }
            }
            
        }else {
            lalel.textColor = UIColor.gray
            
            // 线下
            lalel.snp.makeConstraints { (make) in
                make.height.equalTo(15)
                make.top.equalTo(endPoint.y)
                
                if endPoint.x > width/2 {
                    make.right.equalTo(-(width - endPoint.x))
                    
                }else {
                    make.left.equalTo(endPoint.x)
                }
            }
        }
        return lalel
    }
}

