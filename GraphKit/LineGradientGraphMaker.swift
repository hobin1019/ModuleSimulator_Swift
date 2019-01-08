//
//  Line2GraphMaker.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

public class LineGradientGraphMaker: GraphMaker {
    let detail = ["강력매도", "매도", "중립", "매수", "강력매수"]
    let lineSize = CGSize(width: 300, height: 30)
    let maxDataValue: CGFloat = 5.0
    
    var lineView: UIView!
    var barView: UIView!
    var label: UILabel!
    
    //-------------- Override Functions
    override internal func startAnimation() {
        animating = true
        createLineGraph()
        
        //animation
        barView = UIView(frame: CGRect(x: lineView.frame.origin.x, y: lineView.frame.origin.y - 15, width: 1, height: 10))
        barView.backgroundColor = .white
        view.addSubview(barView)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .beginFromCurrentState, animations: {
            self.barView.frame = CGRect(x: self.lineView.frame.origin.x + (self.lineView.frame.width) * CGFloat(truncating: self.data[0] as! NSNumber) / self.maxDataValue, y: self.lineView.frame.origin.y - 15, width: 1, height: 10)
        }, completion: {(Bool) -> Void in
            let textSize = CGSize(width: 100, height: 40)
            self.label = UILabel(frame: CGRect(x: self.barView.frame.origin.x - textSize.width/2.0, y: self.barView.frame.origin.y - textSize.height - 2, width: textSize.width, height: textSize.height))
            self.label.numberOfLines = 0
            self.label.textColor = .white
            self.label.font = self.label.font.withSize(13)
            self.label.textAlignment = NSTextAlignment.center
            self.label.text = "\(self.detail[Int(self.data[0] as! CGFloat)])\n(\(self.data[0]))"
            self.view.addSubview(self.label)
            self.animating = false
        })
    }
    override internal func removeAll() {
        barView.removeFromSuperview()
        label.removeFromSuperview()
    }
    
    private func createLineGraph() {
        lineView = UIView(frame: CGRect(x: (size.width - lineSize.width) / 2.0, y: (size.height - lineSize.height) / 2.0, width: lineSize.width, height: lineSize.height))
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [colorArr[4].cgColor, colorArr[0].cgColor]
        gradient.frame = lineView.bounds
        lineView.layer.addSublayer(gradient)
        view.addSubview(lineView)
        
        let textSize = CGSize(width: 100, height: 40)
        let minLabel = UILabel(frame: CGRect(x: lineView.frame.origin.x - textSize.width / 2.0, y: lineView.frame.origin.y + lineSize.height + 3, width: textSize.width, height: textSize.height))
        minLabel.textColor = .white
        minLabel.numberOfLines = 0
        minLabel.text = "\(self.detail[0])\n(0.0)"
        minLabel.font = minLabel.font.withSize(13)
        minLabel.textAlignment = .center
        view.addSubview(minLabel)
        let maxLabel = UILabel(frame: CGRect(x: lineView.frame.origin.x + lineSize.width - textSize.width / 2.0, y: lineView.frame.origin.y + lineSize.height + 3, width: textSize.width, height: textSize.height))
        maxLabel.textColor = .white
        maxLabel.numberOfLines = 0
        maxLabel.text = "\(self.detail[4])\n(5.0)"
        maxLabel.font = maxLabel.font.withSize(13)
        maxLabel.textAlignment = .center
//        maxLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(maxLabel)
        
    }
}
