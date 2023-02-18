//
//  OrderSummaryView.swift
//  Oq ot
//
//  Created by AvazbekOS on 11/07/22.
//

import UIKit

class OrderSummaryView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 0.0
        layer.cornerRadius = 16.0
        backgroundColor = .white
        setStyleWithShadow()
        setupView()
        
    }
    
    func setData(data: Any) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backgroundImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "pattern")
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    let orderSummaryLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(17, "orderSummery".translate(), false, UIColor(hex: "#000000", alpha: 0.6), .center)
        return lbl
    }()
    
    let promocodeLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "vaucher/Promo".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return lbl
    }()
    
    lazy var productsLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "0 \("products".translate()):", false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return lbl
    }()
    
    let deliveryLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "\("delivery".translate()):", false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return lbl
    }()
    
    let overAllLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(17, "summery".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return lbl
    }()
    
    let pricePromocodeLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "donthave".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .right)
        return lbl
    }()
    
    lazy var priceProductsLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "zeroSum".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .right)
        return lbl
    }()
    
    let priceDeliveryLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "free".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .right)
        return lbl
    }()
    
    let priceOverAllLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.attributedText = NSAttributedString.getAttrTextWith(17, "zeroSum".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .right)
        return lbl
    }()
    
    lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var stackView1: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.alignment = .leading
        st.distribution = .fillEqually
        st.spacing = 13
        return st
    }()
    
    lazy var stackView2: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.alignment = .trailing
        st.distribution = .fillEqually
        st.spacing = 13
        return st
    }()
    
    let pathLayerDashedTop: CAShapeLayer = {
        let path = CAShapeLayer()
        path.lineWidth = 1
        path.lineDashPattern = [5, 5]
        path.fillColor = UIColor.clear.cgColor
        path.strokeColor = UIColor(hex: "#000000", alpha: 0.3).cgColor
        return path
    }()
    let pathLayerDashedBottom: CAShapeLayer = {
        let path = CAShapeLayer()
        path.lineWidth = 1
        path.lineDashPattern = [5, 5]
        path.fillColor = UIColor.clear.cgColor
        path.strokeColor = UIColor(hex: "#000000", alpha: 0.3).cgColor
        return path
    }()
    override func layoutSubviews() {
        let pathTop = UIBezierPath()
        let  p0 = CGPoint(x: bounds.minX + 25, y: bounds.minY + 55)
        pathTop.move(to: p0)

        let  p1 = CGPoint(x: bounds.maxX - 25, y: bounds.minY + 55)
        pathTop.addLine(to: p1)
        pathLayerDashedTop.path = pathTop.cgPath
        
        let pathBottom = UIBezierPath()
        let  p2 = CGPoint(x: bounds.minX + 25, y: bounds.maxY - 71)
        pathBottom.move(to: p2)

        let  p3 = CGPoint(x: bounds.maxX - 25, y: bounds.maxY - 71)
        pathBottom.addLine(to: p3)
        pathLayerDashedBottom.path = pathBottom.cgPath
        
    }

    
    private func setupView() {
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        addSubview(bottomView)
        
        addSubview(orderSummaryLabel)
        stackView1.addArrangedSubview(promocodeLabel)
        stackView1.addArrangedSubview(productsLabel)
        stackView1.addArrangedSubview(deliveryLabel)
        addSubview(stackView1)
        stackView2.addArrangedSubview(pricePromocodeLabel)
        stackView2.addArrangedSubview(priceProductsLabel)
        stackView2.addArrangedSubview(priceDeliveryLabel)
        addSubview(stackView2)
        
        bottomView.addSubview(overAllLabel)
        bottomView.addSubview(priceOverAllLabel)
        
        orderSummaryLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 150, height: 20))
        orderSummaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 31, right: 25), size: CGSize(width: 0, height: 25))
        overAllLabel.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 70, height: 25))
        priceOverAllLabel.anchor(top: bottomView.topAnchor, leading: nil, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 150, height: 25))
    
        
        stackView1.anchor(top: orderSummaryLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 38, left: 25, bottom: 38, right: 0), size: CGSize(width: (SCREEN_SIZE.width - 50) / 2, height: 0))

        stackView2.anchor(top: orderSummaryLabel.bottomAnchor, leading: nil, bottom: bottomView.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 38, left: 0, bottom: 38, right: 25), size: CGSize(width: (SCREEN_SIZE.width - 50) / 2, height: 0))
        
        layer.addSublayer(pathLayerDashedTop)
        layer.addSublayer(pathLayerDashedBottom)
      
    }

}


