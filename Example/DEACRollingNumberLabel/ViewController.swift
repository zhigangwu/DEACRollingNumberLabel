//
//  ViewController.swift
//  DEACRollingNumberLabel
//
//  Created by 12740181 on 11/09/2023.
//  Copyright (c) 2023 12740181. All rights reserved.
//

import UIKit
import DEACRollingNumberLabel

class ViewController: UIViewController {
    
    let rollingNumberLabel = DEACRollingNumberLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        rollingNumberLabel.frame = CGRect(x: 100, y: 200, width: 50, height: 25)
        rollingNumberLabel.text_font = UIFont.systemFont(ofSize: 22, weight: .medium)
        rollingNumberLabel.text_color = .red
        self.view.addSubview(rollingNumberLabel)
        rollingNumberLabel.initBasicValue(default_value: "234", scrollMode: .Individual)
        
        let addButton = UIButton(frame: CGRect(x: 100, y: 300, width: 60, height: 25))
        addButton.setTitle("+1", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .orange
        addButton.addTarget(self, action: #selector(clickAddButton), for: .touchUpInside)
        self.view.addSubview(addButton)

    }
    
    @objc func clickAddButton() {
//        self.rollingNumberLabel.changeValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

