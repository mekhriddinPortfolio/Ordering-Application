//
//  GradientView.swift
//  Oq ot
//
//  Created by Mekhriddin on 07/07/22.
//

import UIKit

class GradiendView: UIView {
    
    var color1 = Theme.current.gradientLabelColors[0]
    var color2 = Theme.current.gradientLabelColors[1]

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [color1, color2]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

