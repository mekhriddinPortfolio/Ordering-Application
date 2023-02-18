//
//  CustomTextField.swift
//  Oq ot
//
//  Created by Mekhriddin on 07/07/22.
//

import UIKit


class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String, textAlignment: NSTextAlignment, text: String?) {
        super.init(frame: .zero)
        configure()
        self.textAlignment = textAlignment
        self.placeholder = placeholder
        self.text = text
    }
    
    
    private func configure() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = Theme.current.textFieldBorderColor
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        textColor = .black
        tintColor = .black
        placeholder = "Placeholder"
        backgroundColor = Theme.current.whiteBackColor
        autocorrectionType = .no
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 16)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 10*RatioCoeff.width)

       override open func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override open func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
}


