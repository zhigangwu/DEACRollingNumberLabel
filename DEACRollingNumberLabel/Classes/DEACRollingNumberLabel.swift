//
//  DEACRollingNumberLabel.swift
//  DEACRollingNumberLabel_Example
//
//  Created by Ryan on 2023/11/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

enum DEACScrollMode {
    case Together // 多个滚动
    case Individual // 单独滚动
}

public class DEACRollingNumberLabel: UIView {

    var scrollMode : DEACScrollMode? = .Individual
    
    let doubleValue = 63764
    var pointIndex : Int?
    var viewArray : NSMutableArray = []
    
    let scrollLabelView = ScrollLabelView()
    var current_value : String?
    
    var text_font : UIFont? {
        didSet {
            scrollLabelView.currentLabel_Font = text_font ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        }
    }
    
    var text_color : UIColor? = nil {
        didSet {
            if text_color == nil {
                scrollLabelView.currentLabel_Color = .black
            } else {
                scrollLabelView.currentLabel_Color = text_color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    func initBasicValue(default_value : String, scrollMode : DEACScrollMode) {
        self.scrollMode = scrollMode
        self.current_value = default_value
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        if scrollMode == .Together {
            scrollLabelView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.addSubview(scrollLabelView)
            scrollLabelView.initBasic(default_value)
        } else {
            let moreView = UIView(frame: CGRect(x: 0, y: 0, width: 25 * default_value.count, height: Int(self.frame.height)))
            self.addSubview(moreView)
            
            for i in 0..<default_value.count {
                let index1 = default_value.index(default_value.startIndex, offsetBy: i)

                let moreScrollLabelView = ScrollLabelView(frame: CGRect(x: i * 25, y: 0, width: 25, height: Int(self.frame.height)))
                moreScrollLabelView.currentLabel_Font = self.text_font
                moreScrollLabelView.currentLabel_Color = self.text_color
                moreScrollLabelView.tag = i
                let index_value = String(default_value[index1])
                if moreScrollLabelView.currentLabel.text == "." {
                    pointIndex = i
                }
                moreView.addSubview(moreScrollLabelView)
                moreScrollLabelView.initBasic(index_value)
                
                viewArray.add(moreScrollLabelView)
            }
        }
    }
    
    func changeValue() {
        if self.scrollMode == .Together {
            self.scrollLabelView.changeValue()
        } else {
            let indexInt : Int?
            if pointIndex != nil {
                 indexInt = pointIndex! - 1
            } else {
                indexInt = (self.current_value ?? "0").count - 1
            }
            
            startScroll(index: indexInt!)
        }
    }
    
    func startScroll(index : Int) {
        var moreScrollLabelView = ScrollLabelView()
        moreScrollLabelView = viewArray[index] as! ScrollLabelView
        
        var moreUnderLabelValue = Int(moreScrollLabelView.currentLabel.text!)! + 1
        if moreUnderLabelValue == 10 {
            moreScrollLabelView.currentLabel.text = "0"
            moreUnderLabelValue = 0
            startScroll(index: index - 1)
        }
        moreScrollLabelView.underLabel.text = String(moreUnderLabelValue)
        
        UIView.animate(withDuration: 0.3) {
            moreScrollLabelView.currentLabel.frame = CGRect(x: 0, y: -25, width: 25, height: 25)
            moreScrollLabelView.underLabel.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        } completion: { (Bool) in
            moreScrollLabelView.currentLabel.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            moreScrollLabelView.underLabel.frame = CGRect(x: 0, y: 25, width: 25, height: 25)
            moreScrollLabelView.currentLabel.text = String(moreUnderLabelValue)
            moreScrollLabelView.underLabel.text = String(moreUnderLabelValue + 1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrollLabelView: UIView {
    
    let scrollView = UIScrollView()
    let currentLabel = UILabel()
    let underLabel = UILabel()
    
    var currentLabel_Font : UIFont? {
        didSet {
            currentLabel.font = currentLabel_Font
            underLabel.font = currentLabel_Font
        }
    }
    
    var currentLabel_Color : UIColor? {
        didSet {
            currentLabel.textColor = currentLabel_Color
            underLabel.textColor = currentLabel_Color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        currentLabel.textAlignment = .center
        scrollView.addSubview(currentLabel)
        
        underLabel.textAlignment = .center
        scrollView.addSubview(underLabel)

    }
    
    func initBasic(_ value : String) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 2)
        currentLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        underLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        
        currentLabel.text = value

    }
    
    func changeValue() {
        let underLabelValue = Int(self.currentLabel.text!)! + 1
        self.underLabel.text = String(underLabelValue)
        UIView.animate(withDuration: 0.3) {
            self.currentLabel.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
            self.underLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        } completion: { (Bool) in
            self.currentLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.underLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
            self.currentLabel.text = String(underLabelValue)
            self.underLabel.text = "0"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
