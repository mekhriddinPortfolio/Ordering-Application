//
//  SmsConfirmController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 04/07/22.
//

import Foundation
import UIKit

class SmsConfirmController: BaseViewController {
    
    var phoneNumber: String = ""
    let viewModel = AuthRequestModel()
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    var secondsRemaining = 180
    var timerTest: Timer? = nil
    lazy var tfArray = [TF1,TF2,TF3,TF4,TF5,TF6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        activateTimer()
        
        viewModel.didVerifyPhoneNumber = { [weak self] responce, error in 
            guard let self = self else { return }
            defer {
                self.hideProcessing()
            }
            if responce?.statusCode == 200 {
                let vc = RegController()
                vc.phoneNumber = self.phoneNumber
                self.perform(transition: vc)
                print("Success")
            } else if responce?.statusCode == 202 {
                if let wrappedResponce = responce?.resultValue as? Params {
                    print("x\nx\nToken", wrappedResponce.stringOrEmpty(for: "token"))
                    UD.tokenType = wrappedResponce.stringOrEmpty(for: "tokenType")
                    UD.token = wrappedResponce.stringOrEmpty(for: "token")
                    UD.expiresAt = wrappedResponce.stringOrEmpty(for: "expiresAt")
                    UD.refreshToken = wrappedResponce.stringOrEmpty(for: "refreshToken")
                    AppDelegate.shared?.setRoot(viewController: MainTabbarController(isRegistered: true))
                    print("Accepted")
                }
            } else if responce?.statusCode == 404 {
                self.tfArray.forEach { tf in
                    tf.layer.borderColor = Theme.current.redColor.cgColor
                }
                print("Failure")
            }
        }
        
        viewModel.didSendValidationCode = { [weak self] responce, error in
            guard let self = self else { return }
            if responce?.statusCode == 200 {
                self.secondsRemaining = 180
                self.activateTimer()
                print("Success")
            } else if responce?.statusCode == 400 {
                print("Bad request")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfArray.forEach { tf in
            tf.textAlignment = .center
            tf.layer.borderWidth = 1
            tf.layer.borderColor = UIColor(hex: "#E8ECF4").cgColor
            tf.layer.cornerRadius = 8
            tf.delegate = self
            tf.keyboardType = .numberPad
            tf.textColor = UIColor(hex: "#000000", alpha: 0.5)
            tf.font = UIFont.boldSystemFont(ofSize: 22)
            tf.backgroundColor = UIColor(hex: "F7F8F9")
        }
    }
    
    @objc private func adjustForKeyboard() {
        self.widthConstraint?.constant = self.view.frame.size.width/5
        self.heightConstraint?.constant = self.view.frame.size.width/5
        UIView.animate(withDuration: 2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func adjustForHide() {
        self.widthConstraint?.constant = self.view.frame.size.width/2.5
        self.heightConstraint?.constant = self.view.frame.size.width/2.5
        UIView.animate(withDuration: 2, delay: 0) {
            self.view.layoutIfNeeded()
        }
       
    }
    @objc private func viewPressed() {
        view.endEditing(true)
    }
    
    lazy var topImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "imageSmsTop")
        return im
    }()
    
    lazy var firstText: UILabel = {
        let im = UILabel()
        im.attributedText = NSAttributedString.getAttrTextWith(22, "checkNumber".translate())
        return im
    }()
    
    lazy var firstTextDes: UILabel = {
        let im = UILabel()
        im.numberOfLines = 0
        im.attributedText = NSAttributedString.getAttrTextWith(16, "enterVerCode".translate())
        return im
    }()
    
    
    lazy var TF1: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.textContentType = .oneTimeCode
        return tf
    }()
    
    lazy var TF2: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    
    lazy var TF3: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    lazy var TF4: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    
    lazy var TF5: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    
    lazy var TF6: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.contentMode = .center
        stack.spacing = 13
        stack.addArrangedSubview(TF1)
        stack.addArrangedSubview(TF2)
        stack.addArrangedSubview(TF3)
        stack.addArrangedSubview(TF4)
        stack.addArrangedSubview(TF5)
        stack.addArrangedSubview(TF6)
        return stack
    }()
    
    lazy var nextButton: BaseButton = {
        let l = BaseButton()

        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
        l.contentHorizontalAlignment = .center
        l.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
      
        l.layer.cornerRadius = 8
        l.layer.borderColor = Theme.current.textFieldBorderColor
        l.layer.borderWidth = 1.0
        l.backgroundColor = Theme.current.grayBackgraoundColor
        return l
    }()
    
    @objc func nextButtonTapped() {
        print("next Button Tapped")
        var verifyCode: String = ""
        for tf in tfArray {
            verifyCode += tf.text.notNullString
        }
        self.showProcessing()
        viewModel.verifyPhoneNumber(verificationCode: verifyCode, phoneNumber: phoneNumber)
        // gooo to next to screen....
    }
    
    private func setupView() {
        view.addSubview(topImageView)
        view.addSubview(firstText)
        view.addSubview(firstTextDes)
        view.addSubview(textFieldStackView)
        view.addSubview(nextButton)
        view.addSubview(sendSmsAgainLabel)
        
        nextButton.gradientLayer.removeFromSuperlayer()
        
        topImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0))
        
         widthConstraint = NSLayoutConstraint(item: topImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/2.5)
        heightConstraint = NSLayoutConstraint(item: topImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/2.5)
        topImageView.addConstraint(widthConstraint!)
        topImageView.addConstraint(heightConstraint!)
        topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstText.anchor(top: topImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 30))
        
        firstTextDes.anchor(top: firstText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        
        textFieldStackView.anchor(top: firstTextDes.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: (view.frame.size.width - 97)/6))
        nextButton.anchor(top: textFieldStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        
        sendSmsAgainLabel.anchor(top: nextButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 23 * 2))
        sendSmsAgainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    lazy var sendSmsAgainLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.attributedText = NSAttributedString.getAttrTextWith(15, "Запросить код повторно можно через 0:30 сек", false, UIColor(hex: "#000000", alpha: 0.5), .center)
        l.isUserInteractionEnabled = false
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSendSms)))
        return l
    }()
    
    @objc private func didTapSendSms() {
        viewModel.sendValidationNumber(phoneNumber: String.clearString(str: phoneNumber))
    }
    
    func activateTimer() {
        self.sendSmsAgainLabel.isUserInteractionEnabled = false
        timerTest = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (Timer) in
            guard let self = self else {return}
              if self.secondsRemaining > 0 {
                  Utils.delay(seconds: 0) {
                      let minutes = String(self.secondsRemaining / 60)
                      let seconds = String(self.secondsRemaining % 60)
                     let countDownText = minutes + ":" + seconds
                      self.sendSmsAgainLabel.attributedText = NSAttributedString.getAttrTextWith(15, "\("canSentAgain".translate()) \(countDownText) \("sentAgainTimer".translate())", false, UIColor(hex: "#000000", alpha: 0.5), .center)
                  }
                  self.secondsRemaining -= 1
              } else {
                  self.sendSmsAgainLabel.attributedText = NSAttributedString.getAttrTextWith(15, "sentAgain".translate())
                  self.sendSmsAgainLabel.isUserInteractionEnabled = true
//                  let leftPoint = CGPoint(x: self.sendSmsAgainButton.frame.minX + 50, y: self.sendSmsAgainButton.bounds.maxY)
//                  let rightPoint = CGPoint(x: self.sendSmsAgainButton.frame.maxX - 50, y: self.sendSmsAgainButton.bounds.maxY)
//
//                  self.sendSmsAgainButton.createDashedLine(from: leftPoint, to: rightPoint, color: .black, strokeLength: 1, gapLength: 3, width: 1)
                  Timer.invalidate()
              }
          }
    }
    
    
    
    
}

extension SmsConfirmController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") {
            textField.text = string
            if textField == TF1 {
                TF2.becomeFirstResponder()
            }
            else if textField == TF2 {
                TF3.becomeFirstResponder()
            }
            else if textField == TF3 {
                TF4.becomeFirstResponder()
            }
            else if textField == TF4 {
                TF5.becomeFirstResponder()
            }
            else if textField == TF5 {
                TF6.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder()
            }
            if !TF1.text!.isEmpty && !TF2.text!.isEmpty && !TF3.text!.isEmpty && !TF4.text!.isEmpty && !TF5.text!.isEmpty && !TF6.text!.isEmpty{
                self.nextButton.isUserInteractionEnabled = true
                nextButton.layer.insertSublayer(nextButton.gradientLayer, at: 0)
                nextButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#FFFFFF")), for: .normal)
                nextButton.layer.borderWidth = 0.0
            }
            return false
        } else {
            textField.text = string
            if textField == TF1 {
                textField.resignFirstResponder()
            }
            else if textField == TF2 {
                TF1.becomeFirstResponder()
            }
            else if textField == TF3 {
                TF2.becomeFirstResponder()
            }
            else if textField == TF4 {
                TF3.becomeFirstResponder()
            }
            else if textField == TF5 {
                TF4.becomeFirstResponder()
            }
            else {
                TF5.becomeFirstResponder()
            }
            nextButton.gradientLayer.removeFromSuperlayer()
            nextButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "confirmButton".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
            nextButton.layer.borderWidth = 1.0
            self.nextButton.isUserInteractionEnabled = false
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
}

extension UIButton {

    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]

        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
