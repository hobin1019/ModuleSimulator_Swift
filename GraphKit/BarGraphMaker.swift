//
//  BarGraphView.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

public class BarGraphMaker: GraphMaker {
    let barPadding: CGFloat = 10
    var barNum: Int!
    var barWidth: CGFloat!
    
    var barViews: [UIView]!
    var dotViews: [UIView]!
    var lineLayers: [CAShapeLayer]!

    //-------------- Override Functions
    override public init(size: CGSize, data: NSArray) {
        barNum = data.count
        barWidth = (size.width - barPadding * CGFloat(barNum - 1)) / CGFloat(barNum)
        super.init(size: size, data: data)
    }
    override internal func startAnimation() {
        animating = true
        createBarGraph()
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .beginFromCurrentState, animations: {
            for i in 0..<self.data.count {
                let barHeight: CGFloat = (self.size.height * CGFloat(self.data[i] as! Int) / 100.0)
                self.barViews[i].frame = CGRect(x: self.barWidth * CGFloat(i) + self.barPadding * CGFloat(i), y: self.size.height - barHeight, width: self.barWidth, height: barHeight)
            }
        }, completion: {(Bool) -> Void in
            self.createLineGraph()
            self.animating = false
        })
    }
    override internal func removeAll() {
        for i in 0..<barViews.count {
            barViews[i].removeFromSuperview()
        }
        for i in 0..<dotViews.count {
            dotViews[i].removeFromSuperview()
        }
        for i in 0..<lineLayers.count {
            lineLayers[i].removeFromSuperlayer()
        }
        barViews = nil
        dotViews = nil
        lineLayers = nil
    }
    
    // ---------------- 막대 그래프
    private func createBarGraph() {
        barViews = NSArray() as? [UIView]
        for i in 0..<barNum {
            let barView: UIView = UIView(frame: CGRect(x: barWidth * CGFloat(i) + barPadding * CGFloat(i), y: size.height, width: barWidth, height: 0))
            view.addSubview(barView)
            barView.backgroundColor = colorArr[i % colorArr.count] as UIColor
            
            barViews.append(barView)
        }
    }
    // ------------- 꺾은선 그래프
    private func createLineGraph() {
        dotViews = NSArray() as? [UIView]
        lineLayers = NSArray() as? [CAShapeLayer]
        
        let dotSize: CGFloat = 5
        var posX = barWidth / 2 - dotSize/2
        for i in 0..<barNum {
            var posY = view.frame.height * (1 - CGFloat(data[i] as! Int) / CGFloat(100))
            if posY == view.frame.height {posY = view.frame.height * 0.99}
            
            let dotView: UIView = UIView(frame: CGRect(x: posX , y: posY, width: dotSize, height: dotSize))
            dotView.backgroundColor = blueColor
            view.addSubview(dotView)
            
            posX += barWidth + barPadding
            dotViews.append(dotView)
        }
        
        for i in 0..<barNum - 1 {
            let startPoint: CGPoint = (dotViews?[i].center)!
            let endPoint: CGPoint = (dotViews?[i+1].center)!
            
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = blueColor.cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
            
            lineLayers.append(shapeLayer)
        }
    }
}
