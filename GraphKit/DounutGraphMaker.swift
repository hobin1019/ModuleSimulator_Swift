//
//  DounutGraphView.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

public class DounutGraphMaker : GraphMaker {
    var dounutShapeLayer: [CAShapeLayer]!
    var dounutTextLayer: [CATextLayer]!
    
    //-------------- Override Functions
    override internal func startAnimation() {
        animating = true
        createDounutGraph()
        startDounutAnimation(idx: 0)
    }
    override internal func removeAll() {
        for i in 0..<data.count {
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = 0
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            dounutShapeLayer[i].add(basicAnimation, forKey: "urSoBasic")
            dounutTextLayer[i].removeFromSuperlayer()
        }
        dounutShapeLayer = nil
        dounutTextLayer = nil
    }
    
    //-------------- Private Functions
    private func startDounutAnimation(idx: Int) {
        CATransaction.begin()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(1.0 / CGFloat(data.count))
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        //animation
        CATransaction.setCompletionBlock {
            if(idx + 1 < self.data.count) {
                self.startDounutAnimation(idx: idx + 1)
            } else {
                // all animation finished
                self.setDounutTextLayer()
            }
        }
        dounutShapeLayer[idx].add(basicAnimation, forKey: "urSoBasic")
        CATransaction.commit()
    }
    private func setDounutTextLayer() {
        dounutTextLayer = NSArray() as? [CATextLayer]
        var valueSum: Int = 0
        for i in 0..<data.count {
            valueSum += data[i] as! Int
        }
        
        let textSize = CGSize(width: 50, height: 20)
        var angle: CGFloat = -CGFloat.pi / 2.0
        for i in 0..<data.count {
            angle += CGFloat.pi * 2.0 * CGFloat(self.data[i] as! Int) / CGFloat(valueSum) / 2.0
            let radius: CGFloat = 100
            let textPoint: CGPoint = CGPoint(x: radius * cos(angle), y: radius * sin(angle))
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: size.width/2.0 + textPoint.x - textSize.width/2.0, y: size.height/2.0 - textSize.height/2.0 + textPoint.y, width: textSize.width, height: textSize.height)
            textLayer.alignmentMode = .center
            textLayer.string = "\(String(format: "%.2f", CGFloat(data[i] as! Int) / CGFloat(valueSum) * 100.0))%"
            textLayer.foregroundColor = UIColor.black.cgColor
            //            textLayer.backgroundColor = UIColor.white.cgColor
            textLayer.fontSize = 15
            textLayer.isWrapped = true
            view.layer.addSublayer(textLayer)
            angle += CGFloat.pi * 2.0 * CGFloat(data[i] as! Int) / CGFloat(valueSum) / 2.0
            
            dounutTextLayer.append(textLayer)
        }
        self.animating = false
    }
    
    private func createDounutGraph() {
        dounutShapeLayer = NSArray() as? [CAShapeLayer]
        
        let trakerPath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0), radius: 100, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = trakerPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 30
        trackLayer.strokeEnd = 1
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
        
        var valueSum: Int = 0
        for i in 0..<data.count {
            valueSum += data[i] as! Int
        }
        var startAng = -CGFloat.pi/2
        for i in 0..<data.count {
            let percentValue = CGFloat(data[i] as! Int) / CGFloat(valueSum)
            let endAng = startAng + CGFloat.pi * 2 * percentValue
            let shapePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0), radius: 100, startAngle: startAng, endAngle: endAng, clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = shapePath.cgPath
            shapeLayer.strokeColor = colorArr[i % colorArr.count].cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 30
            shapeLayer.strokeEnd = 0
            shapeLayer.lineCap = .butt
            
            view.layer.addSublayer(shapeLayer)
            startAng = endAng
            dounutShapeLayer.append(shapeLayer)
        }
    }
}
