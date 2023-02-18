//
//  CustomButton.swift
//  Oq ot
//
//  Created by Mekhriddin on 07/07/22.
//

import UIKit

class BaseButton: UIButton {
    
    var color1 = Theme.current.gradientColor1
    var color2 = Theme.current.gradientColor2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, size: CGFloat) {
        self.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString.getAttrTextWith(size, title, false, Theme.current.whiteColor), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [color1.cgColor, color2.cgColor]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
    }
    
    func setInitialState() {
        
    }
    
    func setStateOn() {
        
    }
}
