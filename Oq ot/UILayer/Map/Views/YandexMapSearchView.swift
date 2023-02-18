//
//  YandexMapSearchView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 05/07/22.
//

import Foundation
import UIKit

class YandexMapSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var resultLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.text = "searchResults".translate()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = Theme.current.blackColor.withAlphaComponent(0.5) 
        return l
    }()
    
    
    private func setupView() {
        let topView = Utils.getTopView(color: .lightGray)
        addSubview(topView)
        addSubview(topLabel)
        addSubview(searchContainerview)
        searchContainerview.addSubview(separatorView)
        searchContainerview.addSubview(searchImageView)
        searchContainerview.addSubview(searchTextField)
        searchContainerview.addSubview(mapLabel)
        addSubview(confirmButton)
        addSubview(resultLabel)
        
        topView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLabel.anchor(top: topView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 20))
        topLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchContainerview.anchor(top: topLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        searchImageView.anchor(top: nil, leading: searchContainerview.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 17.38, height: 18))
        searchImageView.centerYAnchor.constraint(equalTo: searchContainerview.centerYAnchor).isActive = true
        mapLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: searchContainerview.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 37, height: 15))
        mapLabel.centerYAnchor.constraint(equalTo: searchContainerview.centerYAnchor).isActive = true
        separatorView.anchor(top: nil, leading: nil, bottom: nil, trailing: mapLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 2, height: 24))
        separatorView.centerYAnchor.constraint(equalTo: searchContainerview.centerYAnchor).isActive = true
        searchTextField.anchor(top: searchContainerview.topAnchor, leading: searchImageView.trailingAnchor, bottom: searchContainerview.bottomAnchor, trailing: separatorView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 4), size: CGSize(width: 0, height: 50))
        searchTextField.centerYAnchor.constraint(equalTo: searchContainerview.centerYAnchor).isActive = true
        // 115+
        confirmButton.anchor(top: searchContainerview.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 20, right: 20), size: CGSize(width: 0, height: 50))
        // 65+
        resultLabel.anchor(top: searchContainerview.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 15))
        // 35+
    }
    
    lazy var searchImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "search")
        return im
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = Theme.current.searchBGColor
        tf.attributedPlaceholder = NSAttributedString.getAttrTextWith(13, "search".translate(), false, Theme.current.searchBGColor, .left)
        tf.font = UIFont.systemFont(ofSize: 13)
        return tf
    }()
    
    lazy var mapLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(13, "map".translate(), false, Theme.current.searchBGColor, .center)
        l.isUserInteractionEnabled = true
        return l
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorLineBackColor
        //        v.transform = v.transform.rotated(by: .pi / 2)    // 90˚
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    let searchContainerview: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.searchContainerColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 7
        return v
    }()
    
    lazy var topLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "addAddress".translate(), false, .black)
        return l
    }()
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton()
        l.isUserInteractionEnabled = true
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "save".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
        l.contentHorizontalAlignment = .center
        return l
    }()
    
    
}




