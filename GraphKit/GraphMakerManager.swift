//
//  GraphManager.swift
//  GraphSimulator
//
//  Created by WISEfn on 12/26/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit

enum GraphType: CaseIterable {
    case Line
    case LineGradient
    case Lines
    case Bar
    case Dounut
}

public class GraphMaker {
    public let colorArr = [UIColor(red: 141/255, green: 17/255, blue: 65/255, alpha: 1),
                    UIColor(red: 170/255, green: 64/255, blue: 108/255, alpha: 1),
                    UIColor(red: 184/255, green: 104/255, blue: 132/255, alpha: 1),
                    UIColor(red: 213/255, green: 162/255, blue: 181/255, alpha: 1),
                    UIColor(red: 244/255, green: 232/255, blue: 237/255, alpha: 1)]
    public let blueColor = UIColor(red: 23/255, green: 108/255, blue: 222/255, alpha: 1)
    public let fourColorArr = [UIColor(red: 160/255, green: 30/255, blue: 70/255, alpha: 1),
                        UIColor(red: 238/255, green: 214/255, blue: 38/255, alpha: 1),
                      UIColor(red: 17/255, green: 141/255, blue: 65/255, alpha: 1),
                      UIColor(red: 72/255, green: 125/255, blue: 206/255, alpha: 1)]
    
    var view: UIView!
    var data: NSArray!
    var animating: Bool = false
    var size: CGSize!
    
    // to override
    public init(size: CGSize, data: NSArray) {
        // set constant
        self.size = size
        self.data = data
        
        // set view
        view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.backgroundColor = .clear
        
        startAnimation()
    }
    public func getView() -> UIView {
        return view
    }
    public func animationBtnClicked() {
        if(animating) {return}
        removeAll()
        startAnimation()
    }
    internal func removeAll() {}
    internal func startAnimation() {}
}
