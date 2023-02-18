//
//  BottomIconCollectionCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 05/07/22.
//

import UIKit

class BottomIconCollectionCell: UICollectionViewCell {
    
    static let identifier = "BottomIconCollectionCell"
    
    func setData(imageName: String) {
        imageV.image = UIImage.init(named: imageName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageV: UIImageView = {
        let l = UIImageView()
        l.contentMode = .scaleAspectFit
        return l
    }()
    
    private func setupView() {
        
        addSubview(imageV)
        imageV.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0), size: CGSize(width: 24, height: 24))
        imageV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Theme.current.textFieldBorderColor
        self.backgroundColor = Theme.current.grayBackgraoundColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
    }
    
    
    
}
