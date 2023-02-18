//
//  ReceiveMessageCollectionViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 21/07/22.
//

import UIKit

class ReceiveMessageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReceiveMessageCollectionViewCell"
    
    private lazy var gradientView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = Theme.current.messageBackColor
        headerView.layer.masksToBounds = true
        headerView.clipsToBounds = true
        return headerView
    }()
    
    private lazy var receiveLabel: UILabel = {
        let receiveLabel = UILabel()
        receiveLabel.translatesAutoresizingMaskIntoConstraints = false
        receiveLabel.font = UIFont.systemFont(ofSize: 15)
        receiveLabel.backgroundColor = .clear
        receiveLabel.textColor = .black
        receiveLabel.numberOfLines = 0
        receiveLabel.lineBreakMode = .byWordWrapping
        return receiveLabel
    }()
    
    lazy var clockLabel: UILabel = {
        let l = UILabel()
        l.text = "00:00"
        l.textColor = Theme.current.recievedMessColor
        l.font = UIFont.systemFont(ofSize: 10)
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        gradientView.addSubview(receiveLabel)
        addSubview(gradientView)
        gradientView.addSubview(clockLabel)
        
        gradientView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 267, height: 0))
        receiveLabel.anchor(top: gradientView.topAnchor, leading: gradientView.leadingAnchor, bottom: gradientView.bottomAnchor, trailing: clockLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), size: CGSize(width: 0, height: 0))
        clockLabel.anchor(top: nil, leading: nil, bottom: gradientView.bottomAnchor, trailing: gradientView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 11), size: CGSize(width: 30, height: 12))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.roundCorners([.topRight, .bottomRight, .bottomLeft], radius: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(_ model: EachMessage) {
        receiveLabel.text = model.body
        clockLabel.text = getTimeFromString(date: model.createdAt)
    }
}
