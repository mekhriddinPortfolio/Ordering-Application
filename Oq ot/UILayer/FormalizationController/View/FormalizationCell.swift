//
//  FormalizationCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 27/07/22.
//

import UIKit

protocol FormalizationCellProtocol: AnyObject {
    func didEndCommiting(comment text: String)
    func didEndChosingTime(date text: String)
}

class FormalizationCell: UICollectionViewCell, UITextViewDelegate, UITextFieldDelegate  {

    weak var delegate: FormalizationCellProtocol?
    var isSoonFormalization = true
    var orderSummaryView = OrderSummaryView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        soonPickupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(soonViewTapped)))
        clearTextField.inputView = dateTimePicker.inputView
        backgroundColor = .white
    }
    
    func setOrderSummaryData(count: Int, summaryPrice: String) {
        orderSummaryView.productsLabel.attributedText = NSAttributedString.getAttrTextWith(13, "\(count) \("products".translate()):", false, UIColor(hex: "#000000", alpha: 0.4), .left)
        orderSummaryView.priceProductsLabel.attributedText = NSAttributedString.getAttrTextWith(13, summaryPrice, false, UIColor(hex: "#000000", alpha: 0.4), .right)
        orderSummaryView.priceOverAllLabel.attributedText = NSAttributedString.getAttrTextWith(17, summaryPrice, false, UIColor(hex: "#000000", alpha: 0.4), .right)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: (SCREEN_SIZE.width) - 2*16, height: 56)
        gradientLayer2.frame = CGRect(x: 0, y: 0, width: (SCREEN_SIZE.width) - 2*16, height: 56)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods .....
    @objc private func soonViewTapped() {
        endEditing(true)
        
        if !isSoonFormalization {
        Utils.removeSublayer(laterPickupView, layerIndex: 0)
        soonPickupView.layer.insertSublayer(gradientLayer1, at: 0)
            
        laterPickupLabel.textColor = UIColor(hex: "#000000", alpha: 0.22)
        dateImageView.image = UIImage(named: "calendar")?.tint(with: UIColor(hex: "#FF4000", alpha: 0.4))

        soonPickupLabel.textColor = .white
        clockImageView.image = UIImage(named: "clock")?.tint(with:.white)
            delegate?.didEndChosingTime(date: "")
        isSoonFormalization = true
        }
    }
    
    @objc private func laterViewTapped() {
        if isSoonFormalization {
        Utils.removeSublayer(soonPickupView, layerIndex: 0)
        laterPickupView.layer.insertSublayer(gradientLayer2, at: 0)
            
        soonPickupLabel.textColor = UIColor(hex: "#000000", alpha: 0.22)
        clockImageView.image = UIImage(named: "clock")?.tint(with: UIColor(hex: "#FF4000", alpha: 0.4))
            
        laterPickupLabel.textColor = .white
        dateImageView.image = UIImage(named: "calendar")?.tint(with: .white)

        isSoonFormalization = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == clearTextField {
                self.laterViewTapped()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == clearTextField {
            delegate?.didEndChosingTime(date: laterPickupLabel.text.notNullString)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextfield.text == "commentsToCourier".translate() {
            commentTextfield.text = ""
            commentTextfield.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == commentTextfield {
            if commentTextfield.text == "" {
                commentTextfield.text = "commentsToCourier".translate()
                commentTextfield.textColor = UIColor(hex: "#000000", alpha: 0.22)
            }
            delegate?.didEndCommiting(comment: commentTextfield.text)
        }
    }
    // -----------
    
    private lazy var dateTimePicker: DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] startDate, startDay in
            let text = Date.buildTimeRangeString(startDate: startDate, startDay: startDay)
            let formattedDate = self?.formattedDateFromString(dateString: text, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
            if let date = formattedDate, date.count > 5 {
                self?.laterPickupLabel.text = "\(date.dropLast(5))Z"
            }
           
        }
        return picker
    }()
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    // -----------
    lazy var commentLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "comments".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    
    lazy var commentTextfield: UITextView = {
        
        let textV = UITextView()
        textV.translatesAutoresizingMaskIntoConstraints = false
        textV.font = .systemFont(ofSize: 15)
        textV.textColor = UIColor(hex: "#000000", alpha: 0.22)
        textV.text = "commentsToCourier".translate()
        textV.textAlignment = .left
        textV.backgroundColor = .white
        textV.layer.borderWidth = 1.0
        textV.layer.borderColor = Theme.current.gradientLabelColors[0]
        textV.layer.cornerRadius = 10
        textV.isScrollEnabled = false
        textV.delegate = self
        textV.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return textV
    }()
    
    lazy var callView: UIView = {
       let v = UIView()
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(hex: "#5CCD34")
        return v
    }()
    lazy var callImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "tick")
        return iV
    }()
    
    
    lazy var secondPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "DateOfDelivery".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    

    lazy var soonPickupView: UIView = {
       let v = GradiendView()
        v.gradientLayer.cornerRadius = 10
        v.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10
        return v
    }()
    lazy var soonPickupLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = .white
//        l.textColor = UIColor(hex: "#000000", alpha: 0.22)
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "comingSoon".translate()
        return l
    }()
    lazy var clockImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "clock")?.tint(with: .white)
//        iV.image = UIImage(named: "clock")?.tint(with: UIColor(hex: "#FF4000", alpha: 0.4))
        return iV
    }()
    
    lazy var laterPickupView: UIView = {
       let v = UIView()
        v.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10
        v.isUserInteractionEnabled = true
        v.backgroundColor = .clear
        return v
    }()
    lazy var clearTextField: LoginTextField = {
        let textField = LoginTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.delegate = self
        return textField
    }()
    lazy var laterPickupLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor(hex: "#000000", alpha: 0.22)
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "chooseDate".translate()
        return l
    }()
    lazy var dateImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "calendar")?.tint(with: UIColor(hex: "#FF4000", alpha: 0.4))
        return iV
    }()
    
    lazy var gradientLayer1: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 10
        return l
    }()
    lazy var gradientLayer2: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 10
        return l
    }()
    
    lazy var thirdPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "payment".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    lazy var cashView: UIView = {
       let v = UIView()
        v.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10
        v.isUserInteractionEnabled = true
        v.backgroundColor = .clear
        return v
    }()
    lazy var cashLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor(hex: "#000000", alpha: 0.4)
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "cash".translate()
        return l
    }()
    lazy var cashSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF4000", alpha: 0.4)
        return view
    }()
    lazy var cashImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "cash")?.tint(with: UIColor(hex: "#000000"))
        return iV
    }()
    
    lazy var creditCardView: UIView = {
       let v = UIView()
        v.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10
        v.isUserInteractionEnabled = true
        v.backgroundColor = .clear
        return v
    }()
    lazy var creditCardLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor(hex: "#000000", alpha: 0.4)
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "terminalUZcard".translate()
        return l
    }()
    lazy var creditCardSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF4000", alpha: 0.4)
        return view
    }()
    lazy var creditCardImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "credit-card")?.tint(with: UIColor(hex: "#000000", alpha: 0.4))
        return iV
    }()
    
    lazy var fourthPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "promocode".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    lazy var promoView: GradiendView = {
       let v = GradiendView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.gradientLayer.cornerRadius = 10
        return v
    }()
    
    lazy var promoLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "enterPromocode".translate()
        return l
    }()
    lazy var promoImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "promo")?.tint(with: UIColor.white)
        return iV
    }()
    
    lazy var fifthPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "question".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    lazy var techSupportView: GradiendView = {
        let v = GradiendView()
         v.layer.cornerRadius = 10
         v.clipsToBounds = true
         return v
         v.gradientLayer.cornerRadius = 10
        return v
    }()
    lazy var techSupportLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.text = "technicalSupport".translate()
        return l
    }()
    lazy var techSupportImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "techSupport")?.tint(with: UIColor.white)
        return iV
    }()
    
    private func setupView() {
        addSubview(commentLabel)
        addSubview(commentTextfield)
        
        addSubview(secondPartLabel)
        
        addSubview(soonPickupView)
        soonPickupView.addSubview(soonPickupLabel)
        soonPickupView.addSubview(clockImageView)
        addSubview(laterPickupView)
        addSubview(clearTextField)
        laterPickupView.addSubview(laterPickupLabel)
        laterPickupView.addSubview(dateImageView)
        
        addSubview(thirdPartLabel)
        
        addSubview(cashView)
        cashView.addSubview(cashLabel)
        cashView.addSubview(cashSeparatorLine)
        cashView.addSubview(cashImageView)
        addSubview(creditCardView)
        cashView.addSubview(creditCardLabel)
        cashView.addSubview(creditCardSeparatorLine)
        cashView.addSubview(creditCardImageView)
        
        addSubview(fourthPartLabel)
        
        addSubview(promoView)
        promoView.addSubview(promoLabel)
        promoView.addSubview(promoImageView)
        
        addSubview(fifthPartLabel)
        
        addSubview(techSupportView)
        techSupportView.addSubview(techSupportLabel)
        techSupportView.addSubview(techSupportImageView)
        
        addSubview(orderSummaryView)
        
        commentLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 17))
        commentTextfield.anchor(top: commentLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 100))
        // 127+ without top constrait of commentLabel
        secondPartLabel.anchor(top: commentTextfield.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 12, bottom: 16, right: 16), size: CGSize(width: 0, height: 20))
        // 84+
        soonPickupView.anchor(top: secondPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        clockImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: soonPickupView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), size: CGSize(width: 23, height: 23))
        clockImageView.centerYAnchor.constraint(equalTo: soonPickupView.centerYAnchor).isActive = true
        soonPickupLabel.anchor(top: soonPickupView.topAnchor, leading: soonPickupView.leadingAnchor, bottom: soonPickupView.bottomAnchor, trailing: clockImageView.leadingAnchor, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 50), size: CGSize(width: 0, height: 17))
        
        laterPickupView.anchor(top: soonPickupView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        dateImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: laterPickupView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), size: CGSize(width: 23, height: 23))
        dateImageView.centerYAnchor.constraint(equalTo: laterPickupView.centerYAnchor).isActive = true
        laterPickupLabel.anchor(top: laterPickupView.topAnchor, leading: laterPickupView.leadingAnchor, bottom: laterPickupView.bottomAnchor, trailing: dateImageView.leadingAnchor, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 50), size: CGSize(width: 0, height: 17))
        clearTextField.anchor(top: laterPickupView.topAnchor, leading: laterPickupView.leadingAnchor, bottom: laterPickupView.bottomAnchor, trailing: laterPickupView.trailingAnchor)
        // 117+
        thirdPartLabel.anchor(top: laterPickupView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 12, bottom: 16, right: 16), size: CGSize(width: 0, height: 20))
        // 84+
        cashView.anchor(top: thirdPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        cashImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: cashView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), size: CGSize(width: 23, height: 23))
        cashImageView.centerYAnchor.constraint(equalTo: cashView.centerYAnchor).isActive = true
        cashSeparatorLine.anchor(top: cashView.topAnchor, leading: nil, bottom: cashView.bottomAnchor, trailing: cashImageView.leadingAnchor, padding: UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 17), size: CGSize(width: 1, height: 0))
        cashLabel.anchor(top: cashView.topAnchor, leading: cashView.leadingAnchor, bottom: cashView.bottomAnchor, trailing: cashSeparatorLine.leadingAnchor, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 10), size: CGSize(width: 0, height: 17))
        
        creditCardView.anchor(top: cashView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        creditCardImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: creditCardView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), size: CGSize(width: 23, height: 23))
        creditCardImageView.centerYAnchor.constraint(equalTo: creditCardView.centerYAnchor).isActive = true
        creditCardSeparatorLine.anchor(top: creditCardView.topAnchor, leading: nil, bottom: creditCardView.bottomAnchor, trailing: creditCardImageView.leadingAnchor, padding: UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 17), size: CGSize(width: 1, height: 0))
        creditCardLabel.anchor(top: creditCardView.topAnchor, leading: creditCardView.leadingAnchor, bottom: creditCardView.bottomAnchor, trailing: creditCardSeparatorLine.leadingAnchor, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 10), size: CGSize(width: 0, height: 17))
        // 117+
        fourthPartLabel.anchor(top: creditCardView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 12, bottom: 16, right: 16), size: CGSize(width: 0, height: 20))
        // 84+
        promoView.anchor(top: fourthPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
       
        promoLabel.anchor(top: promoView.topAnchor, leading: nil, bottom: promoView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 50), size: CGSize(width: 155, height: 17))
        promoLabel.centerXAnchor.constraint(equalTo: promoView.centerXAnchor, constant: 15).isActive = true
        
        promoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: promoLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 22, height: 22))
        promoImageView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        // 56+
        fifthPartLabel.anchor(top: promoView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 12, bottom: 16, right: 16), size: CGSize(width: 0, height: 20))
        // 84+
        techSupportView.anchor(top: fifthPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
       
        techSupportLabel.anchor(top: techSupportView.topAnchor, leading: nil, bottom: techSupportView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 19.5, left: 20, bottom: 19.5, right: 50), size: CGSize(width: 220, height: 17))
        techSupportLabel.centerXAnchor.constraint(equalTo: techSupportView.centerXAnchor, constant: 15).isActive = true
        
        techSupportImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: techSupportLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 24, height: 24))
        techSupportImageView.centerYAnchor.constraint(equalTo: techSupportView.centerYAnchor).isActive = true
        // 56+
        orderSummaryView.anchor(top: techSupportView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 240))
        // height of this cell = 809
    }
}

extension Date {
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = string
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
