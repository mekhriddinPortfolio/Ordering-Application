//
//  MyHeaderFooterClass.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 21/08/22.
//

import UIKit

class MyHeaderFooterClass: UICollectionReusableView {
    
    let titleBottom: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(14, "noMoreAddress".translate(), false, UIColor(hex: "#000000", alpha: 0.3), .center)
        return l
    }()

 override init(frame: CGRect) {
    super.init(frame: frame)
     addSubview(titleBottom)
     titleBottom.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 16))
 }

 required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

 }
}

struct ProfileAddressDataModel {
    let title: String?
}


class MainViewHeaderView: UICollectionReusableView {
    
    let searchView = SearchView()
    let topView = Utils.getTopView(color: Theme.current.searchAndIconsColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.current.whiteColor
        self.topView.isUserInteractionEnabled = true

        addSubview(topView)
        topView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(searchView)
        searchView.anchor(top: topView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: self.frame.size.width - 40, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
