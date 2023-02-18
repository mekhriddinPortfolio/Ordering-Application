//
//  LoginPhoneNumController.swift
//  Oq ot
//
//  Created by AvazbekOS on 05/07/22.
//

import UIKit
import InputMask

class LoginPhoneNumController: BaseViewController {

    let temporaryMask = "+998 ({##}) {###} {##} {##}"
    let listener = MaskedTextFieldDelegate()
    let viewModel = AuthRequestModel()
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    fileprivate var topConstraint1: NSLayoutConstraint?
    fileprivate var topConstraint2: NSLayoutConstraint?
    var canBeSentAgain = true
    
    lazy var phoneImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "phone&letter")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = NSAttributedString.getAttrTextWith(20, "enterPhoneNumber".translate(), false, .black, .center)
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var definitionLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = NSAttributedString.getAttrTextWith(14, "sendVerificationCode".translate(), false, UIColor(hex: "#000000", alpha: 0.5), .center)
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var phoneTextfield: LoginTextField = {
        let l = LoginTextField()
        l.delegate = listener
        l.textColor = Theme.current.headlinesColor
        l.keyboardType = .phonePad
        l.layer.masksToBounds = false
        l.layer.cornerRadius = 8
        l.layer.borderColor = Theme.current.textFieldBorderColor
        l.layer.borderWidth = 1.0
        l.backgroundColor = Theme.current.grayBackgraoundColor
        return l
    }()
    
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton()

        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
        l.contentHorizontalAlignment = .center
        l.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
      
        l.layer.cornerRadius = 8
        l.layer.borderColor = Theme.current.textFieldBorderColor
        l.layer.borderWidth = 1.0
        l.backgroundColor = Theme.current.grayBackgraoundColor
        return l
    }()
   
    
    lazy var bottomDefinitionLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = NSAttributedString.getAttrTextWith(14, "orLoginWith".translate(), false, UIColor(hex: "#000000", alpha: 0.5), .center)
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupListener()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        phoneTextfield.becomeFirstResponder()
        notificationForKeyboard()
        
        viewModel.didSendValidationCode = { [weak self] responce, error in
            guard let self = self else { return }
            defer {
                self.hideProcessing()
            }
            self.canBeSentAgain = true
            
                if responce?.statusCode == 200 {
                    let vc = SmsConfirmController()
                    vc.phoneNumber = String.clearString(str: (self.phoneTextfield.text.notNullString))
                    self.perform(transition: vc)
                    print("Success")
                } else if responce?.statusCode == 400 {
                    print("Bad request")
                }
            
        }
       
        // Do any additional setup after loading the view.
    }
    func notificationForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    private func setupView() {
        // ????
        view.addSubview(phoneImage)
        
        phoneImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
        
        widthConstraint = NSLayoutConstraint(item: phoneImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/1.5)
        heightConstraint = NSLayoutConstraint(item: phoneImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/1.5)
        phoneImage.addConstraint(widthConstraint!)
        phoneImage.addConstraint(heightConstraint!)
        phoneImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 26))
        topConstraint1 = titleLabel.topAnchor.constraint(equalTo: phoneImage.bottomAnchor, constant: 10)
        self.topConstraint2 = titleLabel.topAnchor.constraint(equalTo: phoneImage.bottomAnchor, constant: 53)
        topConstraint1?.isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(definitionLabel)
        definitionLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 16))
        definitionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(phoneTextfield)
        phoneTextfield.anchor(top: definitionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        
        view.addSubview(confirmButton)
        confirmButton.anchor(top: phoneTextfield.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        
//        view.addSubview(bottomDefinitionLabel)
//        bottomDefinitionLabel.anchor(top: confirmButton.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 16))
//        bottomDefinitionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func confirmButtonTapped() {
        if canBeSentAgain {
            self.canBeSentAgain = false
            self.showProcessing()
            viewModel.sendValidationNumber(phoneNumber: String.clearString(str: (self.phoneTextfield.text.notNullString)))
        }
    }
    
    @objc private func viewPressed() {
        view.endEditing(true)
    }
    
//    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
//        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
////        let temporaryMask = "+998 {##} {###} {##} {##}"
//        let range = NSString(string: phoneNumber).range(of: phoneNumber)
//        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
//
//        if shouldRemoveLastDigit {
//            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
//            number = String(number[number.startIndex..<maxIndex])
//        }
//
//        if number.count > maxNumberCount {
//            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
//            number = String(number[number.startIndex..<maxIndex])
//        }
//
//        if number.count == 12 {
//            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "confirmButton".translate(), false,.white), for: .normal)
//                confirmButton.backgroundColor = UIColor(hex: "#DE8706", alpha: 1.0)
//                confirmButton.layer.borderWidth = 0
//        } else {
//            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "confirmButton".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
//                confirmButton.backgroundColor = UIColor(hex: "#F7F8F9", alpha: 1.0)
//                confirmButton.layer.borderWidth = 1
//        }
//            confirmButton.isUserInteractionEnabled = number.count == 12
//
//        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
//        let regRange = number.startIndex..<maxIndex
////        print("here")
//        if number.count < 8 {
////            print("under 8")
//            let pattern = "(\\d{3})(\\d{2})(\\d+)"
//            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
//        } else {
////            print("above 8")
//            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
//            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
//        }
//        return "+" + number
//    }
    
    private func setupListener() {
        listener.set(serverMask: temporaryMask)
        listener.setCustomNotations()
        listener.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
                print("will Show")
                self.widthConstraint?.constant = self.view.frame.size.width/3
                self.heightConstraint?.constant = self.view.frame.size.width/3
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                    self.topConstraint2?.isActive = false
                    self.topConstraint1?.isActive = true
                    self.view.layoutIfNeeded()    // And **HERE**
                } completion: { _ in
                    
                }
    }

    @objc func keyboardWillHide(notification: NSNotification) {

            print("will Hide")
        self.widthConstraint?.constant = self.view.frame.size.width/1.5
        self.heightConstraint?.constant = self.view.frame.size.width/1.5
        self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.topConstraint1?.isActive = false
                self.topConstraint2?.isActive = true
                self.view.layoutIfNeeded()

            } completion: { _ in
                
            }
    }

}

extension LoginPhoneNumController: MaskedTextFieldDelegateListener {
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {

        if complete
        {
            confirmButton.layer.insertSublayer(confirmButton.gradientLayer, at: 0)
            confirmButton.layer.cornerRadius = 8
            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#FFFFFF")), for: .normal)
            confirmButton.layer.borderWidth = 0.0
        }
        else
        {
            confirmButton.gradientLayer.removeFromSuperlayer()
            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
            confirmButton.layer.borderWidth = 1.0
        }
        confirmButton.isUserInteractionEnabled = complete
    }
}

extension MaskedTextFieldDelegate {
    func set(serverMask: String?) {
        if let correctedMask = serverMask?.correctedMaskString {
            primaryMaskFormat = correctedMask
        }
    }

    func setCustomNotations() {
        customNotations = Mask.customNotations
    }
}


public extension Mask {
    static let customNotations: [Notation] = [
        Notation(character: "#", characterSet: CharacterSet(charactersIn: "0123456789"), isOptional: false),
        Notation(character: "X", characterSet: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"), isOptional: false),
        Notation(character: "S", characterSet: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), isOptional: false)
    ]
}

//extension LoginPhoneNumController: UITextFieldDelegate {
//     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let fullString = (textField.text ?? "") + string
//         textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
//         return false
//    }
//}




