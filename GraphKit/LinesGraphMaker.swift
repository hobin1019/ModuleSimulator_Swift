//
//  LinesGraphMaker.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

public class LinesGraphMaker: GraphMaker {
    let dotSize: CGFloat = 5
    var dotNum: Int!
    
    // to remove
    var dotViews: [[UIView]]!
    var lineLayers: [[CAShapeLayer]]!
    var lineAlphaView: UIView!
    
    override public init(size: CGSize, data: NSArray) {
        dotNum = (data[0] as! NSArray).count
        super.init(size: size, data: data)
    }
    override internal func startAnimation() {
        animating = true
        dotViews = NSArray() as? [[UIView]]
        lineLayers = NSArray() as? [[CAShapeLayer]]
        for i in 0..<data.count {
            createLineGraph(idx: i)
        }
        
        // animation
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .beginFromCurrentState, animations: {
            // dot animation (up -> down)
            for i in 0..<self.dotViews.count {
                for j in 0..<self.dotViews[i].count {
                    let posY = self.size.height * (1 - CGFloat((self.data![i] as! NSArray)[j] as! Int) / CGFloat(100))
                    self.dotViews[i][j].frame = CGRect(x: self.dotViews[i][j].frame.origin.x, y: posY, width: self.dotSize, height: self.dotSize)
                }
            }
        }, completion: {(Bool) -> Void in
            // create line
            self.lineAlphaView = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.size.width, height: self.size.height))
            for i in 0..<self.dotViews.count {
                for j in 0..<self.dotViews[i].count - 1 {
                    let path = UIBezierPath()
                    path.move(to: self.dotViews[i][j].center)
                    path.addLine(to: self.dotViews[i][j+1].center)
                    
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.strokeColor = self.fourColorArr[i].cgColor
                    shapeLayer.lineWidth = 1.0
                    self.lineAlphaView.layer.addSublayer(shapeLayer)
                    self.view.addSubview(self.lineAlphaView)
                    self.lineLayers[i].append(shapeLayer)
                }
            }
            // line animation (fade in)
            self.lineAlphaView.alpha = 0
            UIView.animate(withDuration: 1.0, delay: 0.2, options: .layoutSubviews, animations: {
                self.lineAlphaView.alpha = 1.0
            }, completion: {(Bool) -> Void in self.animating = false})
        })
    }
    override internal func removeAll() {
        for i in 0..<dotViews.count {
            for j in 0..<dotViews[i].count {
                dotViews[i][j].removeFromSuperview()
            }
        }
        for i in 0..<lineLayers.count {
            for j in 0..<lineLayers[i].count {
                lineLayers[i][j].removeFromSuperlayer()
            }
        }
        
        dotViews = nil
        lineLayers = nil
        lineAlphaView = nil
    }
    
    private func createLineGraph(idx: Int) {
        dotViews.append(NSArray() as! [UIView])
        lineLayers.append(NSArray() as! [CAShapeLayer])
        let lineData: NSArray = data![idx] as! NSArray
        
        let dotPadding: CGFloat = size.width / CGFloat(lineData.count - 1)
        var posX = -dotSize/2
        for _ in 0..<dotNum {
            let dotView: UIView = UIView(frame: CGRect(x: posX , y: 0, width: dotSize, height: dotSize))
            dotView.backgroundColor = fourColorArr[idx]
            view.addSubview(dotView)
            posX += dotPadding
            
            dotViews[idx].append(dotView)
        }
    }
}
