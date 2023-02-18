//
//  PaymentTypeCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 05/08/22.
//

import UIKit

class PaymentTypeCell: UICollectionViewCell {
    
    var widthOfText: CGFloat? {
        didSet {
            self.widthConstraint?.constant = widthOfText ?? 10
            layoutIfNeeded()
            }
    }
    var widthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(data: PaymentTypeModel) {
        cellLabel.attributedText = NSAttributedString.getAttrTextWith(15, data.text, false, UIColor.white, .left)
        cellImageView.image = UIImage(named: data.image)
        self.widthOfText = data.text.widthOfString(usingFont: UIFont.systemFont(ofSize: 17))
    }
    
    lazy var cellView: GradiendView = {
       let v = GradiendView()
        v.layer.borderColor = UIColor(hex: "#FF4000").cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10
        v.gradientLayer.cornerRadius = 10
        return v
    }()
    lazy var cellLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.backgroundColor = .clear
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    lazy var cellImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        return iV
    }()
    
    private func setupView() {
        addSubview(cellView)
        cellView.addSubview(cellLabel)
        cellView.addSubview(cellImageView)
        
        cellView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        widthConstraint = NSLayoutConstraint(item: cellLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10)
        cellLabel.addConstraint(widthConstraint!)
        cellLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        cellLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor, constant: 15).isActive = true
        
        cellImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: cellLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 24, height: 24))
        cellImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }
}
