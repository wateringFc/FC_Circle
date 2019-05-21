//
//  ViewController.swift
//  Circle
//
//  Created by FC on 2019/5/20.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addFCPieView()
    }
    
    /// 画饼图
    private func addFCPieView() {
        let data:[CGFloat] = [1 , 1.5, 2.5, 0.5, 2, 2.5, 2, 2.5]
        let color = [UIColor.green,
                     UIColor.red,
                     UIColor.lightGray,
                     UIColor.black,
                     UIColor.purple,
                     UIColor.cyan,
                     UIColor.yellow,
                     UIColor.gray]
        let upText = ["111", "222", "333", "444", "555", "666", "777", "888"]
        let down = ["aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg", "hhh"]
        
        let pieView = FCPieView(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 220), datas: data, colors: color, upTexts: upText, downTexts: down, middle:"总资产")
        view.addSubview(pieView)
    }
    
    
    
    
}

