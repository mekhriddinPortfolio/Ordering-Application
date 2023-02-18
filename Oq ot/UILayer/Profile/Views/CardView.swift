//
//  CardView.swift
//  LanguagePart
//
//  Created by AvazbekOS on 09/07/22.
//

import UIKit

class CardView: UICollectionViewCell {

    static let identifier = "CardViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        layer.cornerRadius = 10
        backgroundColor = UIColor(hex: "#DE8706")
//        backgroundColor = UIColor(patternImage: UIImage(named: "backCard")!.tint(with: UIColor(hex: "#DE8706")))
    }
    
    func setData(data: EachCard) {
        self.cardName.text = data.name
        self.cardNumber.text = data.cardNumber
        self.cardDate.text = data.dateOfIssue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backImage: UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "backCard")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cardName: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "Uzcard", false, UIColor.white, .left)
        l.backgroundColor = .clear
        return l
    }()
    
    lazy var cardNumber: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(20, "8600 **** **** 1248", false, UIColor.white, .left)
        l.backgroundColor = .clear
        return l
    }()
    
    lazy var cardImage: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "uzcard")
        im.backgroundColor = .clear
        return im
    }()
    
    lazy var cardDate: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "04/24", false, UIColor.white, .left)
        l.backgroundColor = .clear
        return l
    }()
    
    private func setupView() {
        insertSubview(backImage, at: 0)
        backImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        addSubview(cardName)
        cardName.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 120, height: 20))
        
        addSubview(cardNumber)
        cardNumber.anchor(top: cardName.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 200, height: 23))
        
        addSubview(cardImage)
        cardImage.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0), size: CGSize(width: 25, height: 36))
        
        addSubview(cardDate)
        cardDate.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20), size: CGSize(width: 40, height: 15))
    }
    
    

}
