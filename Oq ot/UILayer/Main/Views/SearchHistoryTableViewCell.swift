//
//  SearchHistoryTableViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 18/09/22.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.headlinesColor.withAlphaComponent(0.08)
        return view
    }()
    
    private lazy var clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "history 1")
        return imageView
    }()
    
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(15, "Kit Kat", false, UIColor(hex: "#000000", alpha: 0.6), .left)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.current.whiteColor
        configureContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(productName: String, isLast: Bool) {
        myLabel.text = productName
        separatorView.backgroundColor = isLast ? Theme.current.headlinesColor.withAlphaComponent(0.08) : UIColor.clear
    }
    
    private func configureContraints() {
        addSubview(clockImageView)
        addSubview(myLabel)
        addSubview(separatorView)
        clockImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        clockImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myLabel.anchor(top: nil, leading: clockImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 16), size: CGSize(width: 0, height: 20))
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
    }
    

}
