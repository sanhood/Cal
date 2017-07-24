//
//  HighlightView.swift
//  Cal
//
//  Created by Soroush Shahi on 7/24/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
//

import UIKit


class HighlightView: UIView , CAAnimationDelegate{

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation stopped")
        let smallAnimation = CABasicAnimation(keyPath: "cornerRadius")
        smallAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        smallAnimation.fromValue = NSNumber(floatLiteral: 40 )
        smallAnimation.toValue = NSNumber(floatLiteral: 10)
        smallAnimation.duration = 0.3
        self.layer.add(smallAnimation, forKey: "cornerRadius")
        
        
        self.layer.cornerRadius = 10

    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 100

    }
    
    
    
    func didUnHidden () {
        let bigAnimation = CABasicAnimation(keyPath: "cornerRadius")
        bigAnimation.delegate = self
        bigAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        bigAnimation.fromValue = NSNumber(floatLiteral: 0)
        bigAnimation.toValue = NSNumber(floatLiteral: 30)
        bigAnimation.duration = 0.1
        self.layer.add(bigAnimation, forKey: "cornerRadius")
        
        
        
        
        self.layer.cornerRadius = 30
        
       
        
        
        
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
