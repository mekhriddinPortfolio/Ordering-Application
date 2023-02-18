//
//  RecomendationItemsCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 14/07/22.
//

import UIKit
import Kingfisher

protocol RecomendationItemsCellProtocol: AnyObject {
    func reloadCollection(afterLike: Bool)
}

class RecomendationItemsCell: UICollectionViewCell {
   var liked = false
    
    weak var delegate: RecomendationItemsCellProtocol?
    
    var item: EachDiscountedGood? {
        didSet {
            let count = CoreDataSyncManager.shared.getItemCount(id: item?.id)
            let isLiked = CoreDataSyncManager.shared.isItemLiked(id: item?.id)
            self.liked = isLiked
            self.likedView.isHidden = false
            likeTapped(like: isLiked)
            self.basketView.isHidden = false
            if count > 0 {
                self.stepper.amountOfItem = count
                self.stepper.isHidden = false
                self.basketView.isHidden = true
            }
            
            if item?.count == 0 {
                self.itemNotAvailableLabel.isHidden = false
                self.stepper.isHidden = true
                self.basketView.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.skidkaView.isHidden = true
        self.stepper.isHidden = true
        self.basketView.isHidden = true
        self.likedView.isHidden = true
        self.itemNotAvailableLabel.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F7F7F7")
        layer.cornerRadius = 10
        stepper.isHidden = true
        itemNotAvailableLabel.isHidden = true
        basketView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(basketTapped)))
        likedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likedTapped)))
        stepper.plusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPlusTapCustomStepper)))
        stepper.minusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didMiusTapCustomStepper)))
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(item: EachDiscountedGood, categoryName: String) {
        self.item = item
        nameLabel.attributedText = NSAttributedString.getAttrTextWith(15, item.name , false, UIColor(hex: "#000000", alpha: 0.7), .center, 0, 0, .byTruncatingTail)
        imageView.kf.setImage(with: URL(string: item.photoPath ?? ""))
        categoryLabel.attributedText = NSAttributedString.getAttrTextWith(13, categoryName , false , UIColor(hex: "#000000", alpha: 0.3), .center, 0, 0, .byTruncatingTail)
        
        let discountedPrice = (1.0 - item.discount) * Double(item.sellingPrice)
        priceLabel.attributedText = NSAttributedString.getAttrTextWith(17, Utils.numberToCurrency(number: Int(discountedPrice)), false, UIColor(hex: "#000000", alpha: 0.7), .center, 0, 0, .byCharWrapping)
        if item.discount != 0 {
            skidkaLabel.attributedText = NSAttributedString.getAttrTextWith(12, "\(Utils.numberToCurrency(number: item.sellingPrice))", false, .white, .center, 0, 0, .byWordWrapping, isneedStrikethrough: true)
            skidkaView.isHidden = false
        }
    }
    
    lazy var skidkaView: GradiendView = {
        let v = GradiendView()
        v.gradientLayer.cornerRadius = 20/2
        v.gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        v.isHidden = true
        return v
    }()
    
    lazy var skidkaLabel: UILabel = {
        let l = UILabel()
//        l.clipsToBounds = true
//        l.layer.cornerRadius = 28
//        l.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
//        l.isHidden = true
        l.adjustsFontSizeToFitWidth = true
        l.setStyleWithShadow()
        return l
    }()
    
    lazy var likedView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#000000", alpha: 0.05)
        v.layer.cornerRadius = 29 / 2
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var likedImgView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "likeEmpty")
        
        return im
    }()
    
    lazy var imageView: UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .clear
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "kSnikers")
        return im
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.attributedText = NSAttributedString.getAttrTextWith(14, "Snickers", false, UIColor(hex: "#000000", alpha: 0.7), .center, 0, 0, .byCharWrapping)
        return l
    }()
    
    lazy var categoryLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "шоколад", false , UIColor(hex: "#000000", alpha: 0.3), .center, 0, 0, .byTruncatingTail)
        return l
    }()
    
    lazy var priceLabel: GradientLabel = {
        let l = GradientLabel()
        l.gradientColors = Theme.current.gradientLabelColors
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.attributedText = NSAttributedString.getAttrTextWith(17, "10 000 \("sum".translate())", false, UIColor(hex: "#000000", alpha: 0.7), .center, 0, 0, .byCharWrapping)
        return l
    }()
    
    lazy var basketView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 7
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var basketImgView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "tabBasket")!.tint(with: UIColor(hex: "#BBBBBB"))
        return im
    }()
    
    lazy var itemNotAvailableLabel: UILabel = {
        let l = UILabel()
        l.layer.backgroundColor = UIColor.white.cgColor
        l.layer.cornerRadius = 7
        l.attributedText = NSAttributedString.getAttrTextWith(12, "Нет в наличии")
        return l
    }()
    
    lazy var stepper: CustomStepper = {
        let v = CustomStepper(frame: CGRect(x: 0, y: 0, width: 0, height: 40), isInsideInfo: false)
        v.isInsideMain = true
        v.backgroundColor = .white
        v.layer.cornerRadius = 7
        v.layer.borderWidth = 0.0
        v.amountLabel.attributedText = NSAttributedString.getAttrTextWith(17, "\(5)", false, UIColor(hex: "#7A7A7A"))
        v.plusView.backgroundColor = UIColor(hex: "#EDEDED")
        v.minusView.backgroundColor = UIColor(hex: "#EDEDED")
        v.imagePlusView.image = UIImage.init(named: "Step_plusIcon")?.tint(with: UIColor(hex: "#9C9C9C"))
        v.imageMinusView.image = UIImage.init(named: "Step_minusIcon")?.tint(with: UIColor(hex: "#9C9C9C"))
        return v
    }()
    
    private func setupView() {
        addSubview(imageView)
        
        addSubview(skidkaView)
        skidkaView.addSubview(skidkaLabel)
        addSubview(likedView)
        likedView.addSubview(likedImgView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        insertSubview(itemNotAvailableLabel, aboveSubview: basketView)
        
        skidkaView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 3), size: CGSize(width: 65, height: 20))
        skidkaLabel.anchor(top: skidkaView.topAnchor, leading: skidkaView.leadingAnchor, bottom: skidkaView.bottomAnchor, trailing: skidkaView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3))
        
        likedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0), size: CGSize(width: 29, height: 29))
        likedImgView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 13, height: 13))
        likedImgView.centerXAnchor.constraint(equalTo: likedView.centerXAnchor).isActive = true
        likedImgView.centerYAnchor.constraint(equalTo: likedView.centerYAnchor).isActive = true
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 100))
        
        nameLabel.anchor(top: imageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 34))
        categoryLabel.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 15))
        priceLabel.anchor(top: categoryLabel
            .bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        
        addSubview(basketView)
        basketView.addSubview(basketImgView)
        basketView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5), size: CGSize(width: 0, height: 37))
        basketImgView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 21, height: 18.46))
        basketImgView.centerXAnchor.constraint(equalTo: basketView.centerXAnchor).isActive = true
        basketImgView.centerYAnchor.constraint(equalTo: basketView.centerYAnchor).isActive = true
        
        addSubview(stepper)
        stepper.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5), size: CGSize(width: 0, height: 37))
        itemNotAvailableLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5), size: CGSize(width: 0, height: 37))
    }
    
    @objc private func basketTapped() {
        basketView.isHidden = true
        stepper.isHidden = false
        CoreDataSyncManager.shared.saveToCoreData(model: item!)
        delegate?.reloadCollection(afterLike: false)
    }
    
    
    private func likeTapped(like: Bool) {
        let color = like ? UIColor(hex: "#FF4000", alpha: 0.05) : UIColor(hex: "#000000", alpha: 0.05)
        let image = like ? UIImage.init(named: "likeFill") : UIImage.init(named: "likeEmpty")
        
        self.likedView.transform = .identity
        self.likedView.backgroundColor = color
        self.likedImgView.image = image
        
    }
    
    @objc private func didPlusTapCustomStepper() {
        CoreDataSyncManager.shared.saveToCoreData(model: item!)
        delegate?.reloadCollection(afterLike: false)
        
    }
    @objc private func didMiusTapCustomStepper() {
        if stepper.amountOfItem > 0 {
            CoreDataSyncManager.shared.updateGoodCount(by: item?.id, shouldAdd: false)
        }
        if stepper.amountOfItem == 0 {
            stepper.isHidden = true
            basketView.isHidden = false
        }
        delegate?.reloadCollection(afterLike: false)
    }
    
    @objc private func likedTapped() {
        CoreDataSyncManager.shared.likeItem(by: item, shouldLike: !liked)
        delegate?.reloadCollection(afterLike: true)
    }
    
    
}
