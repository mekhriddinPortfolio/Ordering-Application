//
//  BasketCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 08/07/22.
//

import UIKit
import Kingfisher

protocol BasketCellProtocol: AnyObject {
    func reloadCollection()
}

class BasketCell: UITableViewCell {
    let colors = Colors()
    var amountItems: Int = 0

    var customStepper = CustomStepper(frame: CGRect(x: 0, y: 0, width: 0, height: 40), isInsideInfo: false)

    var model: Any? {
        didSet {
            self.itemNotAvailableLabel.isHidden = true
            self.customStepper.isHidden = false
            if let model = self.model as? EachDiscountedGood {
                let count = CoreDataSyncManager.shared.getItemCount(id: model.id)
                if count > 0 {
                    self.customStepper.amountOfItem = count
                }
                
                if model.count == 0 {
                    self.itemNotAvailableLabel.isHidden = false
                    self.customStepper.isHidden = true
                }
                
                if model.discount != 0.0 {
                    self.skidkaView.isHidden = false
                }
            }
            
            if let model = self.model as? EachDiscountedGoodForCoreData {
                let count = CoreDataSyncManager.shared.getItemCount(id: model.id)
                if count > 0 {
                    self.customStepper.amountOfItem = count
                }
                
                if model.discount != 0.0 {
                    self.skidkaView.isHidden = false
                }
            }
            
        }
    }
    weak var delegate: BasketCellProtocol?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customStepper.isHidden = true
        self.itemNotAvailableLabel.isHidden = true
        self.skidkaView.isHidden = true
        self.customStepper.amountOfItem = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customStepper.plusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPlusTapCustomStepper)))
        customStepper.minusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didMiusTapCustomStepper)))
        self.skidkaView.isHidden = true
        
        setupView()
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(model: Any) {
        self.model = model
        if let model = model as? EachDiscountedGoodForCoreData {
            itemName.attributedText = NSAttributedString.getAttrTextWith(15, model.name, false , UIColor(hex: "#000000", alpha: 0.7), .left, 0, 0, .byTruncatingTail)
            
            let discountedPrice = (1.0 - Double(model.discount)) * Double(model.sellingPrice)
            itemPrice.attributedText = NSAttributedString.getAttrTextWith(17, Utils.numberToCurrency(number: Int(discountedPrice)), false , UIColor(hex: "#DE8706", alpha: 1.0), .left)
            print("DISCOUNT: \(model.discount)")
            if model.discount != 0.0 {
                skidkaLabel.attributedText = NSAttributedString.getAttrTextWith(12, "\(Utils.numberToCurrency(number: model.sellingPrice))", false, .white, .center, 0, 0, .byWordWrapping, isneedStrikethrough: true)
                skidkaView.isHidden = false
            }
            itemImage.kf.setImage(with: URL(string: model.photoPath))
        }
        
        if let model = model as? EachDiscountedGood {
            itemName.attributedText = NSAttributedString.getAttrTextWith(15, model.name, false , UIColor(hex: "#000000", alpha: 0.7), .left, 0, 0, .byTruncatingTail)
            
            let discountedPrice = (1.0 - Double(model.discount)) * Double(model.sellingPrice)
            itemPrice.attributedText = NSAttributedString.getAttrTextWith(17, Utils.numberToCurrency(number: Int(discountedPrice)), false , UIColor(hex: "#DE8706", alpha: 1.0), .left)
            print("DISCOUNT: \(model.discount)")
            if model.discount != 0.0 {
                skidkaLabel.attributedText = NSAttributedString.getAttrTextWith(12, "\(Utils.numberToCurrency(number: model.sellingPrice))", false, .white, .center, 0, 0, .byWordWrapping, isneedStrikethrough: true)
                skidkaView.isHidden = false
            }
            itemImage.kf.setImage(with: URL(string: model.photoPath ?? ""))
        }
        
        
    }
    
    lazy var infoView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .white
        v.setStyleWithShadow(cornerRadius: 10.0)
        return v
    }()
    
    lazy var skidkaView: GradiendView = {
        let v = GradiendView()
        v.gradientLayer.cornerRadius = 20/2
        v.gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        v.isHidden = true
        return v
    }()
    
    lazy var skidkaLabel: UILabel = {
        let l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.setStyleWithShadow()
        return l
    }()
    
    lazy var itemName: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
//        l.adjustsFontSizeToFitWidth = true
        l.attributedText = NSAttributedString.getAttrTextWith(15, "Барни с вареной сгущенкой", false , UIColor(hex: "#000000", alpha: 0.7), .left, 0, 0, .byTruncatingTail)
        return l
    }()
    
    lazy var itemCategory: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
//        l.adjustsFontSizeToFitWidth = true
        l.attributedText = NSAttributedString.getAttrTextWith(13, "sweets".translate(), false , UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    
    lazy var itemPrice: GradientLabel = {
        let l = GradientLabel()
        
        l.gradientColors = Theme.current.gradientLabelColors
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.attributedText = NSAttributedString.getAttrTextWith(17, "10 000 \("sum".translate())", false , UIColor(hex: "#DE8706", alpha: 1.0), .left)
        return l
    }()
    
    lazy var itemImage: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage(named: "kitkat")
        im.backgroundColor = .clear
        
        return im
    }()
    
    lazy var itemNotAvailableLabel: UILabel = {
        let l = UILabel()
        l.layer.backgroundColor = Theme.current.basketBackgroundColor.cgColor
        l.layer.cornerRadius = 7
        l.isHidden = true
        l.attributedText = NSAttributedString.getAttrTextWith(12, "Нет в наличии")
        return l
    }()
    
    private func setupView() {
        contentView.addSubview(infoView)
        infoView.addSubview(itemImage)
        infoView.addSubview(itemName)
        infoView.addSubview(itemCategory)
        infoView.addSubview(itemPrice)
        infoView.addSubview(customStepper)
        infoView.addSubview(skidkaView)
        skidkaView.addSubview(skidkaLabel)
        infoView.addSubview(itemNotAvailableLabel)
        
        customStepper.anchor(top: nil, leading: nil, bottom: itemPrice.bottomAnchor, trailing: infoView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 110, height: 35))
        infoView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10.0, left: 16, bottom: 0, right: 16))
        itemImage.anchor(top: infoView.topAnchor, leading: infoView.leadingAnchor, bottom: infoView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 0), size: CGSize(width: 55 * RatioCoeff.width, height: 0))
        itemName.anchor(top: infoView.topAnchor, leading: itemImage.trailingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 5), size: CGSize(width: 0, height: 17))
        
        itemPrice.anchor(top: nil, leading: itemName.leadingAnchor, bottom: infoView.bottomAnchor, trailing: customStepper.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), size: CGSize(width: 0, height: 23))
        
        itemCategory.anchor(top: itemName.bottomAnchor, leading: itemName.leadingAnchor, bottom: itemPrice.topAnchor, trailing: infoView.trailingAnchor, padding: UIEdgeInsets(top: 1, left: 0, bottom: 3, right: 0), size: CGSize(width: 0, height: 15))

        skidkaView.anchor(top: infoView.topAnchor, leading: nil, bottom: nil, trailing: infoView.trailingAnchor, padding: UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0), size: CGSize(width: 65, height: 20))
        skidkaLabel.anchor(top: skidkaView.topAnchor, leading: skidkaView.leadingAnchor, bottom: skidkaView.bottomAnchor, trailing: skidkaView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3))
       
        itemNotAvailableLabel.anchor(top: customStepper.topAnchor, leading: customStepper.leadingAnchor, bottom: customStepper.bottomAnchor, trailing: customStepper.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    }
    
    @objc private func didPlusTapCustomStepper() {
        if let model = model as? EachDiscountedGood {
            customStepper.amountOfItem += 1
            CoreDataSyncManager.shared.saveToCoreData(model: model)
            self.delegate?.reloadCollection()
        }
        
        if let model = model as? EachDiscountedGoodForCoreData {
            CoreDataSyncManager.shared.updateGoodCount(by: model.id, shouldAdd: true)
            customStepper.amountOfItem += 1
            self.delegate?.reloadCollection()
        }
        
    }
    @objc private func didMiusTapCustomStepper() {
        if let model = model as? EachDiscountedGood {
            if customStepper.amountOfItem > 0 {
                CoreDataSyncManager.shared.updateGoodCount(by: model.id, shouldAdd: false)
            }
            self.delegate?.reloadCollection()
        }
        
        if let model = model as? EachDiscountedGoodForCoreData {
            if customStepper.amountOfItem > 0 {
                CoreDataSyncManager.shared.updateGoodCount(by: model.id, shouldAdd: false)
                customStepper.amountOfItem -= 1
            }
            self.delegate?.reloadCollection()
        }
        
    }
    
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorRight = UIColor.red.cgColor
        let colorLeft = UIColor(hex: "#FFFFFF").cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorRight, colorLeft]
        self.gl.locations = [0, 0, 1, 1]
    }
}
