//
//  SentMessageCollectionViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 21/07/22.
//

import UIKit

class SentMessageCollectionViewCell: UICollectionViewCell {
    static let identifier = "SentMessageCollectionViewCell"
    
    private lazy var sentLabel: UILabel = {
        let sentLabel = UILabel()
        sentLabel.translatesAutoresizingMaskIntoConstraints = false
        sentLabel.font = UIFont.systemFont(ofSize: 15)
        sentLabel.backgroundColor = .clear
        sentLabel.textColor = .white
        sentLabel.numberOfLines = 0
        sentLabel.lineBreakMode = .byWordWrapping
        return sentLabel
    }()
    
    private lazy var gradientView: GradiendView = {
        let headerView = GradiendView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.masksToBounds = true
        headerView.clipsToBounds = true
        return headerView
    }()
    
    lazy var markImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check2")
        return imageView
    }()
    
    lazy var clockLabel: UILabel = {
        let l = UILabel()
        l.text = "00:00"
        l.textColor = Theme.current.clockLabelColor
        l.font = UIFont.systemFont(ofSize: 10)
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientView.addSubview(sentLabel)
        addSubview(gradientView)
        gradientView.addSubview(markImageView)
        gradientView.addSubview(clockLabel)
        
        gradientView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 267, height: 0))
        sentLabel.anchor(top: gradientView.topAnchor, leading: gradientView.leadingAnchor, bottom: gradientView.bottomAnchor, trailing: clockLabel.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), size: CGSize(width: 0, height: 0))
        markImageView.anchor(top: nil, leading: nil, bottom: gradientView.bottomAnchor, trailing: gradientView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 11, right: 11), size: CGSize(width: 13, height: 7))
        clockLabel.anchor(top: nil, leading: nil, bottom: gradientView.bottomAnchor, trailing: markImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 5), size: CGSize(width: 30, height: 12))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.roundCorners([.topLeft, .bottomRight, .bottomLeft], radius: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(_ model: EachMessage) {
        
        
        
        sentLabel.text = model.body
        clockLabel.text = getTimeFromString(date: model.createdAt)
//        if let recieved = model.didReceived {
//            markImageView.image = recieved ? UIImage(named: "check2") : UIImage(named: "check1")
//            NSLayoutConstraint.activate([
//                markImageView.heightAnchor.constraint(equalToConstant: 6),
//                markImageView.widthAnchor.constraint(equalToConstant: 8.73)
//            ])
//        }
    }
}


extension UICollectionViewCell {
    func getTimeFromString(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        let date: Date? = dateFormatterGet.date(from: date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date!)
        let minutes = calendar.component(.minute, from: date!)
        let minutesString = minutes <= 9 ? "0\(minutes)" : "\(minutes)"
        let hourString = hour <= 9 ? "0\(hour)" : "\(hour)"
        return "\(hourString):\(minutesString)"
    }
}
