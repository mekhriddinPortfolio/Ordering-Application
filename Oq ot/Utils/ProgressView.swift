//
//  ProgressView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 02/08/22.
//


import UIKit


class ProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.clipsToBounds = true
        insertSubview(indicator, aboveSubview: contentView)
        indicator.color = Theme.current.blackColor
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 30, height: 30))
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    lazy var contentView: UIVisualEffectView = {
        let cv = UIVisualEffectView()
        cv.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        cv.alpha = 0.5
        return cv
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    var animatePreloader: Bool {
        get { return indicator.isAnimating }
        set {
            newValue ? indicator.startAnimating() : indicator.stopAnimating()
        }
    }
}
