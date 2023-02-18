//
//  SearchView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 22/08/22.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func editingDidEnd(text: String)
    
}

class SearchView: UIView {
    weak var delegate: SearchViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.backgroundColor = Theme.current.grayBackgraoundColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var textField: CustomTextField = {
        let tf = CustomTextField()
        tf.textColor = Theme.current.searchBGColor
        tf.layer.borderWidth = 0
        tf.backgroundColor = .clear
        tf.attributedPlaceholder = NSAttributedString.getAttrTextWith(13, "search".translate(), false, Theme.current.searchBGColor, .left)
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textColor = UIColor(hex: "#000000", alpha: 0.7)
        tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        tf.delegate = self
        return tf
    }()
    
    lazy var imageV: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "search")?.tintedWithLinearGradientColors(colorsArr: Theme.current.gradientLabelColors)
        return im
    }()
    
    @objc private func editingChanged(_ textField: UITextField) {
        delegate?.editingDidEnd(text: textField.text.notNullString)
    }
    
    lazy var clearImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "clear")
        im.contentMode = .scaleAspectFit
        im.isUserInteractionEnabled = true
        im.isHidden = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearText)))
        return im
    }()
    
    @objc private func clearText() {
        textField.text = ""
        delegate?.editingDidEnd(text: textField.text.notNullString)
    }
    
    private func setupView() {
        addSubview(textField)
        addSubview(imageV)
        addSubview(clearImageView)
        
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 80))
        imageV.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 20, height: 20))
        imageV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        clearImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: imageV.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 14, height: 14))
        clearImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
}

extension SearchView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            clearImageView.isHidden = false
        } else {
            clearImageView.isHidden = true
        }
    }
}
