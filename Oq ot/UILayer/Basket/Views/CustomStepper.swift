//
//  CustomStepper.swift
//  Oq ot
//
//  Created by AvazbekOS on 11/07/22.
//

import UIKit

class CustomStepper: UIView {
    
    var isInsideMain = false
    var isInsideInfo = false

    let color1 = Theme.current.gradientColor1
    let color2 = Theme.current.gradientColor2

    var amountOfItem: Int = 0 {
        didSet {
            if self.amountOfItem >= 0 {
                self.amountLabel.attributedText = NSAttributedString.getAttrTextWith(15, "\(self.amountOfItem)", false, UIColor(hex: "#7A7A7A"))
            }
            
            if self.amountOfItem == 1 {
                let pad: CGFloat = -2.8
                self.minusView.addSubview(imageDelete)
                self.imageDelete.anchor(top: minusView.topAnchor, leading: minusView.leadingAnchor, bottom: minusView.bottomAnchor, trailing: minusView.trailingAnchor, padding: UIEdgeInsets(top: pad, left: pad, bottom: pad, right: pad))
                self.minusView.backgroundColor = .clear
                self.gradientLayer2.isHidden = true
            } else {
                if isInsideMain {
                    self.minusView.backgroundColor = UIColor(hex: "#EDEDED")
                } else {
                    self.minusView.backgroundColor = UIColor(hex: "#DE8706")
                    self.gradientLayer2.isHidden = false
                }
                self.minusView.subviews.forEach { sub in
                    if sub == imageDelete {
                        sub.removeFromSuperview()
                    }
                }
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(hex: "#FFA800").cgColor
        self.layer.borderWidth = 0.7

    }
    
    convenience init(frame: CGRect, isInsideInfo: Bool) {
        self.init(frame: frame)
        self.isInsideInfo = isInsideInfo
        setupView()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = plusView.bounds
        gradientLayer2.frame = minusView.bounds
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [color1.cgColor, color2.cgColor]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 8
        if isInsideMain == false {
            plusView.layer.insertSublayer(l, at: 0)
        }
        return l
    }()
    
    lazy var gradientLayer2: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [color1.cgColor, color2.cgColor]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 8
        if isInsideMain == false {
            minusView.layer.insertSublayer(l, at: 0)
        }
        return l
    }()
 
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var amountLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "\(amountOfItem)", false, .lightGray)
        return l
    }()
    
    lazy var plusView: UIView = {
        let view = UIView()
    
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var minusView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var imagePlusView: UIImageView = {
        let im = UIImageView()
//        im.image = UIImage.imageWithImage(image: UIImage.init(named: "Step_plusIcon")!, scaledToSize: CGSize(width: 12, height: 12)).tint(with: .white)
        im.image = UIImage.init(named: "Step_plusIcon")?.tint(with: .white)
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    lazy var imageMinusView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "Step_minusIcon")?.tint(with: .white)
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    lazy var imageDelete: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "deleteGoodIcon")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    private func setupView() {
        addSubview(amountLabel)
        addSubview(minusView)
        addSubview(plusView)
        minusView.addSubview(imageMinusView)
        plusView.addSubview(imagePlusView)
        let height = self.frame.size.height
        amountLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 30, height: height * 0.5))
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        minusView.anchor(top: isInsideInfo ? topAnchor : nil, leading: leadingAnchor, bottom: isInsideInfo ? bottomAnchor : nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: isInsideInfo ? 6 : 4, bottom: 6, right: 0), size: CGSize(width: height * 0.7, height: height * 0.7))
        plusView.anchor(top: isInsideInfo ? topAnchor : nil, leading: nil, bottom: isInsideInfo ? topAnchor : nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: isInsideInfo ? 6 : 4), size: CGSize(width: height * 0.7, height: height * 0.7))
        plusView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        minusView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        imageMinusView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: height * 0.3, height: height * 0.3))
        imagePlusView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: height * 0.3, height: height * 0.3))
        imageMinusView.centerYAnchor.constraint(equalTo: minusView.centerYAnchor).isActive = true
        imageMinusView.centerXAnchor.constraint(equalTo: minusView.centerXAnchor).isActive = true
        imagePlusView.centerYAnchor.constraint(equalTo: plusView.centerYAnchor).isActive = true
        imagePlusView.centerXAnchor.constraint(equalTo: plusView.centerXAnchor).isActive = true


    }
}
