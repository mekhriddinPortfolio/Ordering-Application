//
//  ChatTimeCollectionViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 21/07/22.
//

import UIKit

class ChatTimeCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChatTimeCollectionViewCell"
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.backgroundColor = .orange.withAlphaComponent(0.2)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.layer.cornerRadius = 18
        timeLabel.clipsToBounds = true
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeLabel)
        
        [
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 100),
            timeLabel.heightAnchor.constraint(equalToConstant: 36)
        ].forEach { $0.isActive = true }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(_ str: String) {
        timeLabel.text = str
    }
}
