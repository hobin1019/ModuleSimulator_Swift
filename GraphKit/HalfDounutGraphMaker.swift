//
//  HalfDounutGraphMaker.swift
//  GraphSimulator
//
//  Created by WISEfn on 1/10/19.
//  Copyright © 2019 FnGuide. All rights reserved.
//

import UIKit

public class HalfDounutGraphMaker : GraphMaker {
    let radius: CGFloat = 50
    
    var dounutShape: CAShapeLayer!
    var percentLabel: UILabel!
    
    //-------------- Override Functions
    override internal func startAnimation() {
        animating = true
        createDounutGraph()
        startDounutAnimation(idx: 0)
    }
    override internal func removeAll() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        dounutShape.add(basicAnimation, forKey: "urSoBasic")
        percentLabel.removeFromSuperview()
        
        dounutShape = nil
        percentLabel = nil
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
        let lblSize = CGSize(width: 50.0, height: 50.0)
        CATransaction.setCompletionBlock {
            self.percentLabel = UILabel(frame: CGRect(x: (self.size.width - lblSize.width) / 2.0, y: (self.size.height - lblSize.height + self.radius) / 2.0, width: lblSize.width, height: lblSize.height))
            self.percentLabel.text = "\(self.data[0] as! CGFloat)%"
            self.view.addSubview(self.percentLabel)
        }
        dounutShape.add(basicAnimation, forKey: "urSoBasic")
        CATransaction.commit()
    }
    
    private func createDounutGraph() {
        let pos = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0 + radius / 2.0)
        let startAngle = -CGFloat.pi
        
        let trakerPath = UIBezierPath(arcCenter: pos, radius: 50, startAngle: startAngle, endAngle: 0, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = trakerPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        trackLayer.strokeEnd = 1
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
        // -CGFloat.pi + CGFloat.pi * (data[0] as! CGFloat) / 100.0
        let shapePath = UIBezierPath(arcCenter: pos, radius: 50, startAngle: startAngle, endAngle: startAngle + CGFloat.pi * (data[0] as! CGFloat) / 100.0, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapePath.cgPath
        shapeLayer.strokeColor = colorArr[0].cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        view.layer.addSublayer(shapeLayer)
        
        dounutShape = shapeLayer
    }
}
