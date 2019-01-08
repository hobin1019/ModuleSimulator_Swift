//
//  LineGraphMaker.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

public class LineGraphMaker: GraphMaker {
    let lineSize: CGSize = CGSize(width: 300, height: 30)
    let maxDataValue: CGFloat = 5.0
    var lineView: UIView!
    
    // to remove
    var barView: UIView!
    var label: UILabel!
    
    //-------------- Override Functions
    override internal func startAnimation() {
        animating = true
        createLineGraph()
        
        barView = UIView(frame: CGRect(x: lineView.frame.origin.x, y: lineView.frame.origin.y - 15, width: 1, height: 10))
        barView.backgroundColor = .white
        view.addSubview(barView)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .beginFromCurrentState, animations: {
            self.barView.frame = CGRect(x: self.lineView.frame.origin.x + (self.lineView.frame.width) * CGFloat(truncating: self.data[0] as! NSNumber) / self.maxDataValue, y: self.lineView.frame.origin.y - 15, width: 1, height: 10)
        }, completion: {(Bool) -> Void in
            let textSize = CGSize(width: 30, height: 20)
            self.label = UILabel(frame: CGRect(x: self.barView.frame.origin.x - textSize.width/2.0, y: self.barView.frame.origin.y - textSize.height - 2, width: textSize.width, height: textSize.height))
            self.label.textColor = .white
            self.label.textAlignment = NSTextAlignment.center
            self.label.text = "\(self.data[0])"
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
        lineView.backgroundColor = .white
        
        var posX: CGFloat = 0.0
        let detail = ["강력매도", "매도", "중립", "매수", "강력매수"]
        for i in 0..<detail.count {
            let tmpLineView = UIView(frame: CGRect(x: posX, y: 0, width: lineSize.width / 5.0, height: lineSize.height))
            tmpLineView.backgroundColor = colorArr[4-i]
            lineView.addSubview(tmpLineView)
            posX += lineSize.width / maxDataValue
            
            let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: lineSize.width / 5.0, height: lineSize.height))
            detailLabel.textColor = .black
            detailLabel.textAlignment = NSTextAlignment.center
            detailLabel.text = detail[i]
            detailLabel.font = detailLabel.font.withSize(10)
            tmpLineView.addSubview(detailLabel)
            
        }
        
        view.addSubview(lineView)
    }
}
