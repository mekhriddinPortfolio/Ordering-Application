//
//  OrderStatusView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 26/07/22.
//

import UIKit


class OrderStatusView: UIView {
    
    let circle = CAShapeLayer()
    let circle2 = CAShapeLayer()
    var lineLayer = CAShapeLayer()
    let leftTitle = UILabel()
    let rightTitle = UILabel()
    let leftTime = UILabel()
    let rightTime = UILabel()
    private var animatingImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addCirclesAndLines()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let lblArray = [leftTitle, leftTime, rightTime, rightTitle]
        lblArray.forEach { lbl in
            addSubview(lbl)
            lbl.translatesAutoresizingMaskIntoConstraints = true
        }
        leftTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 3.5 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        leftTime.anchor(top: leftTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 3.5 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        rightTitle.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 3.5 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        rightTime.anchor(top: rightTitle.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 3.5 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        lblArray.forEach { lbl in
            lbl.sizeToFit()
        }
        leftTitle.attributedText = NSAttributedString.getAttrTextWith(13 * RatioCoeff.width, "Подготовка", false, .black, .left)
        leftTime.attributedText = NSAttributedString.getAttrTextWith(11 * RatioCoeff.width, "15:40", false, .lightGray, .left)
        rightTitle.attributedText = NSAttributedString.getAttrTextWith(13 * RatioCoeff.width, "delivery".translate(), false, .black, .right)
        rightTime.attributedText = NSAttributedString.getAttrTextWith(11 * RatioCoeff.width, "19:40", false, .lightGray, .right)
        
        
    }
    func animateLine(percent: Double) {
        let firstX = "Подготовка".widthOfString(usingFont: UIFont.regular(ofSize: 10 * RatioCoeff.height))
        let position = CGPoint(x: firstX + 50, y: 5)
        let secondX = "delivery".translate().widthOfString(usingFont: UIFont.regular(ofSize: 10 * RatioCoeff.height))
        let layerWidth = SCREEN_SIZE.width - 32 - firstX - secondX - 40
        let toValue = CGPoint(x: position.x + (layerWidth * (percent - 0.2)), y: position.y)
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
            self.animatingImageView.frame = CGRect(origin: toValue, size: CGSize(width: 36 * RatioCoeff.height, height: 36 * RatioCoeff.height))
        } completion: { finished in
            self.layoutIfNeeded()
        }

    }
    
    
    
    
    func addCirclesAndLines() {
        let radius = 6 * RatioCoeff.height
        let circlePath = UIBezierPath()
        let circlePath2 = UIBezierPath()
        let firstX = "Подготовка".widthOfString(usingFont: UIFont.regular(ofSize: 13 * RatioCoeff.width))
        let secondX = "delivery".translate().widthOfString(usingFont: UIFont.regular(ofSize: 13 * RatioCoeff.width))
        let firstCircleCenter = CGPoint(x: firstX + 20, y: 36 * RatioCoeff.height / 2)
        let secondCircleCenter = CGPoint(x: SCREEN_SIZE.width - secondX - 52, y: 36 * RatioCoeff.height / 2)
        let animatingCircleCenter = CGPoint(x: firstX + 50, y: 5)
        
        circlePath.addArc(withCenter: firstCircleCenter, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        circlePath2.addArc(withCenter: secondCircleCenter, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        circlePath.close()
        
        circle.path = circlePath.cgPath
        circle2.path = circlePath2.cgPath
   
       
        
        circle.fillColor = UIColor.orange.cgColor
        //circle.strokeColor = UIColor.red.cgColor
        layer.addSublayer(circle)
        circle2.lineWidth = 1
        circle2.fillColor = UIColor.white.cgColor
        circle2.strokeColor = UIColor.orange.cgColor
        layer.addSublayer(circle2)
            
        lineLayer = getCALayerByPath(from: firstCircleCenter, to: secondCircleCenter)
        layer.insertSublayer(lineLayer, below: circle)
//        animatingCircleLayer.contents = UIImage.init(named:"globe")?.cgImage
//        animatingCircleLayer.contentsGravity = .center
//        animatingCircleLayer.contentsCenter = CGRect(origin: animatingCircleCenter, size: CGSize(width: 20, height: 20))
//        layer.addSublayer(animatingCircleLayer)
        addSubview(animatingImageView)
        animatingImageView.image = UIImage.init(named: "iconCar")
        animatingImageView.frame = CGRect(origin: animatingCircleCenter, size: CGSize(width: 36 * RatioCoeff.height, height: 36 * RatioCoeff.height))
  
    }
  
    
    private func getCALayerByPath (from: CGPoint, to: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        
        let curveLayer = CAShapeLayer()
        curveLayer.path = path.cgPath
        curveLayer.fillColor = nil
        curveLayer.strokeColor = UIColor.gray.cgColor
        curveLayer.lineWidth = 1
        curveLayer.lineDashPattern = [9, 9]
        curveLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        curveLayer.cornerRadius = 1
        return curveLayer
    }
}
