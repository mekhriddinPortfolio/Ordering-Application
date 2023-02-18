//
//  CardTextField.swift
//  Oq ot
//
//  Created by AvazbekOS on 02/08/22.
//

import InputMask
import UIKit

class CardTextField: UITextField {
    func codeNumInit(objDelegate: MaskedTextFieldDelegate? = nil, target: Any, selector: Selector) {

        keyboardAppearance = Theme.current.getThemeColor() == .dark ? .dark : .light
        returnKeyType = .default
        layer.masksToBounds = true
        delegate = objDelegate
        keyboardType = .phonePad
//        autocapitalizationType = .allCharacters
        backgroundColor = .clear
        layer.cornerRadius = 7.0
        textColor = .black
        textAlignment = .left
        font = UIFont.regular(ofSize: 16)
//        tintColor = Theme.current.turquoiseColor
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "#FF4000").cgColor
        rightViewMode = .always
        attributedPlaceholder = NSAttributedString(string: "0000 0000 0000 0000", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        if #available(iOS 13, *) {
            let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
            rightView = rightContainerView
            
            let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            rightBtn.center = rightContainerView.center
            rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBtn.setImage(UIImage.init(named: "qrcode")?.tintedWithLinearGradientColors(colorsArr: Theme.current.gradientLabelColors), for: .normal)
            rightBtn.tintColor = UIColor(hex: "#FF4000")
            rightBtn.addTarget(target, action: selector, for: .touchUpInside)
            rightContainerView.addSubview(rightBtn)
        }
    }
    
    func dateNumInit(objDelegate: MaskedTextFieldDelegate? = nil, target: Any, selector: Selector) {

        keyboardAppearance = Theme.current.getThemeColor() == .dark ? .dark : .light
        returnKeyType = .default
        layer.masksToBounds = true
        delegate = objDelegate
        keyboardType = .phonePad
        backgroundColor = .clear
        layer.cornerRadius = 7.0
        textColor = .black
        textAlignment = .left
        font = UIFont.regular(ofSize: 16)
//        tintColor = Theme.current.turquoiseColor
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "#FF4000").cgColor
        rightViewMode = .always
        attributedPlaceholder = NSAttributedString(string: "00/00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        rightView = rightContainerView
        
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        rightBtn.center = rightContainerView.center
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        rightBtn.setImage(UIImage.init(named: "creditcard")?.tintedWithLinearGradientColors(colorsArr: Theme.current.gradientLabelColors), for: .normal)
        rightBtn.tintColor = UIColor(hex: "#FF4000")
        rightBtn.addTarget(target, action: selector, for: .touchUpInside)
        rightContainerView.addSubview(rightBtn)
        
    }
    
    func codeNameInit() {
        keyboardAppearance = Theme.current.getThemeColor() == .dark ? .dark : .light
        returnKeyType = .default
        layer.masksToBounds = true
        keyboardType = .default
//        autocapitalizationType = .allCharacters
        backgroundColor = .clear
        layer.cornerRadius = 7.0
        textColor = .black
        textAlignment = .left
        font = UIFont.regular(ofSize: 16)
//        tintColor = Theme.current.turquoiseColor
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "#FF4000").cgColor
        attributedPlaceholder = NSAttributedString(string: "EnterCardName".translate(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: frame.height)
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: frame.height)
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: frame.height)
        return bounds.inset(by: padding)
    }
    

}
