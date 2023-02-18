//
//  ProfileTableViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 07/07/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let reuseID = "FavoriteCell"
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        return imageView
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(15, "cell", false, Theme.current.blackColor, .left)
        return label
    }()
    lazy var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "right-arrow 3")
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        backgroundColor = .clear
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.cornerRadius = 0
    }
    
    func set(profile: Profile){
        print("Setting")
        usernameLabel.text = profile.name
        iconImageView.image = UIImage(named: profile.image)
    }
    
    
    private func configure() {
        addSubview(iconImageView)
        addSubview(usernameLabel)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 10
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
        addSubview(rightImageView)
        rightImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 14, height: 14))
        rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
