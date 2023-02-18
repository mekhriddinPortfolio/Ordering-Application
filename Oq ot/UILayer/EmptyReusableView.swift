//
//  EmptyReusableView.swift
//  Oq ot
//
//  Created by AvazbekOS on 23/09/22.
//

import UIKit


class EmptyReusableView: UIView {
    
    var height: CGFloat?
    var leftRightPadding: CGFloat?
    var buttonAction: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageName: String, text: String, desc: String, buttonTitle: String, height: CGFloat, leftRightPadding: CGFloat) {
        self.init(frame: .zero)
        
        emptyImageView.image = UIImage.init(named: imageName)
        textLabel.attributedText = NSAttributedString.getAttrTextWith(20, text, false, Theme.current.blackColor, .center)
        descriptionLabel.attributedText = NSAttributedString.getAttrTextWith(15, desc, false, Theme.current.grayLabelColor5, .center)
        actionButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, buttonTitle, false, Theme.current.whiteColor), for: .normal)
        self.height = height
        self.leftRightPadding = leftRightPadding
        setupView()
    }
    
    lazy var emptyImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "")
        return im
    }()
    
    lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.backgroundColor = .clear
        lbl.attributedText = NSAttributedString.getAttrTextWith(20, "", false, Theme.current.blackColor, .center)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.backgroundColor = .clear
        lbl.attributedText = NSAttributedString.getAttrTextWith(15, "", false, Theme.current.grayLabelColor5, .center)
        return lbl
    }()
    
    lazy var actionButton: BaseButton = {
        let l = BaseButton(title: "", size: 15)
        l.isUserInteractionEnabled = true
        return l
    }()
    

    
    
    private func setupView() {
        addSubview(textLabel)
        addSubview(descriptionLabel)
        addSubview(emptyImageView)
        addSubview(actionButton)
        textLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 23))
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        descriptionLabel.anchor(top: textLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 40))
        emptyImageView.anchor(top: nil, leading: leadingAnchor, bottom: textLabel.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: leftRightPadding ?? 0.0, bottom: 30, right: leftRightPadding ?? 0.0), size: CGSize(width: 0, height: height ?? 0.0))
        emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        actionButton.anchor(top: descriptionLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
    }
    
}
