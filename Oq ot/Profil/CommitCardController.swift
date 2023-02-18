//
//  CommitCardController.swift
//  Oq ot
//
//  Created by AvazbekOS on 06/07/22.
//

import UIKit

class CommitCardController: BaseViewController {
    
    var secondsRemaining = 30
    var timerTest: Timer? = nil

    var backImgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "background")
        img.contentMode = .scaleAspectFit
        img.layer.opacity = 0.3
        return img
    }()
    
    var titleLabel: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.attributedText = NSAttributedString.getAttrTextWith(14, "Для подтверждения карты, введите код из смс, который мы отправили на номер +998 99 ••• •• 99", false, UIColor(hex: "#000000", alpha: 0.5), .center)
        lbl.layer.backgroundColor = UIColor.init(hex: "#FAFAFA").cgColor
        lbl.layer.masksToBounds = false
        lbl.layer.cornerRadius = 8
        return lbl
    }()
    
    lazy var nextButton: BaseButton = {
        let b = BaseButton()
        b.isUserInteractionEnabled = false
        b.backgroundColor = UIColor(hex: "#F7F8F9")
        b.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "Подтвердить", false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
        b.contentHorizontalAlignment = .center
        
        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var sendSmsAgainButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "Запросить код повторно можно через 0:30 сек", false, UIColor(hex: "#000000", alpha: 0.5), .center), for: .normal)
        btn.isUserInteractionEnabled = false
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        btn.addTarget(self, action: #selector(didTapSendSms), for: .touchUpInside)
        return btn
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.contentMode = .center
        stack.spacing = 5
        stack.addArrangedSubview(TF1)
        stack.addArrangedSubview(TF2)
        stack.addArrangedSubview(TF3)
        stack.addArrangedSubview(TF4)
        stack.addArrangedSubview(TF5)
        stack.addArrangedSubview(TF6)
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let tfArray = [TF1,TF2,TF3,TF4, TF5, TF6]
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        activateTimer()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        view.addSubview(backImgView)
        view.addSubview(titleLabel)
        view.addSubview(textFieldStackView)
        view.addSubview(nextButton)
        view.addSubview(sendSmsAgainButton)
        
        backImgView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: -10, left: 20, bottom: 0, right: 0), size: CGSize(width: SCREEN_SIZE.width, height: 200))
        
        titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 124, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 78))
        
        textFieldStackView.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 18, bottom: 0, right: 18), size: CGSize(width: 0, height: (view.frame.size.width - 70)/6))
        
        sendSmsAgainButton.anchor(top: textFieldStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 23))
        
        nextButton.anchor(top: sendSmsAgainButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 16, bottom: 20, right: 16), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        
        
    }
    
    lazy var TF1: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var TF2: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var TF3: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var TF4: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var TF5: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var TF6: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    @objc private func viewPressed() {
        view.endEditing(true)
    }
    
    @objc func nextButtonTapped() {
        print("next Button Tapped")
        
        // gooo to next to screen....
    }
    
    @objc private func didTapSendSms() {
        print("send sms again tapped")
        secondsRemaining = 30
        activateTimer()
        
    }
    func activateTimer() {
        self.sendSmsAgainButton.isUserInteractionEnabled = false
        timerTest = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (Timer) in
            guard let self = self else {return}
              if self.secondsRemaining > 0 {
                  Utils.delay(seconds: 0) {
                      self.sendSmsAgainButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "Запросить код повторно можно через \(self.secondsRemaining) сек"), for: .normal)
                  }
                  self.secondsRemaining -= 1
              } else {
                  self.sendSmsAgainButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "Отправить код ещё раз"), for: .normal)
                  self.sendSmsAgainButton.isUserInteractionEnabled = true
                  Timer.invalidate()
              }
          }
    }

}

extension CommitCardController: UITextFieldDelegate {
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
            if !TF1.text!.isEmpty && !TF2.text!.isEmpty && !TF3.text!.isEmpty && !TF4.text!.isEmpty && !TF5.text!.isEmpty && !TF6.text!.isEmpty  {
                self.nextButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "Подтвердить", false, UIColor(hex: "#FFFFFF", alpha:1.0)), for: .normal)
                self.nextButton.layer.backgroundColor = UIColor(hex: "#DE8706").cgColor
                self.nextButton.isUserInteractionEnabled = true
            }
            return false
        }
        self.nextButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "Подтвердить", false, UIColor(hex: "#000000", alpha:0.3), .center), for: .normal)
        self.nextButton.layer.backgroundColor = UIColor(hex: "#F7F8F9").cgColor
        self.nextButton.isUserInteractionEnabled = false
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
}
