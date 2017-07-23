//
//  Days.swift
//  Cal
//
//  Created by Soroush Shahi on 7/23/17.
//  Copyright © 2017 Danoosh Chamani. All rights reserved.
//

import UIKit

class DayLabel: UILabel {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    
    func commonInit () {
        self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
