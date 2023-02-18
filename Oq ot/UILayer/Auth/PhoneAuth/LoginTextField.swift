//
//  LoginTextField.swift
//  Oq ot
//
//  Created by AvazbekOS on 05/07/22.
//

import UIKit

class LoginTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)

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

extension AKMaskField {

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
    }
}
