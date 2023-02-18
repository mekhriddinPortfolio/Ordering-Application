//
//  InfoProductSlideUpViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 20/07/22.
//

import UIKit

class InfoProductSlideUpViewController: BaseViewController {
    
    var liked = false {
        didSet {
            likeTapped(like: liked)
        }
    }
    
    var shouldReloadCollection: (() -> Void)?
    
    var item: EachDiscountedGood? {
        didSet {
            let count = CoreDataSyncManager.shared.getItemCount(id: item?.id)
            let isLiked = CoreDataSyncManager.shared.isItemLiked(id: item?.id)
            self.liked = isLiked
            self.likedView.isHidden = false
            likeTapped(like: isLiked)
            if count >= 0 {
                self.customStepper.amountOfItem = count
            }
        }
    }
    
    // MARK: - Properties
    
    func setData(model: EachDiscountedGood?) {
        self.item = model
        if let url = URL.init(string: model?.photoPath ?? "") {
            imageView.kf.setImage(with: url)
        }
        self.productNameLabel.attributedText = NSAttributedString.getAttrTextWith(17, model?.name ?? "", false, Theme.current.grayLabelColor7, .left)
        self.productTypeLabel.attributedText = NSAttributedString.getAttrTextWith(14, "" , false, Theme.current.grayLabelColor5, .left)
        if let sellingPrice = model?.sellingPrice {
            self.productCostLabel.attributedText = NSAttributedString.getAttrTextWith(18, "\(sellingPrice)", false, Theme.current.grayLabelColor7, .left)
        }
       
        if model?.discount != 0.0 {
            self.previousProductCostLabel.attributedText = NSAttributedString.getAttrTextWith(14,Utils.numberToCurrency(number: (model!.sellingPrice)), false, Theme.current.redColor, .left, isneedStrikethrough: true)
        }
        self.productInfoTextView.attributedText = NSAttributedString.getAttrTextWith(14, model?.description ?? "", false, Theme.current.grayLabelColor4, .left)
        if item?.count == 0 {
            self.customButton.alpha = 0.3
            self.customButton.isEnabled = false
            self.customStepper.isUserInteractionEnabled = false
        }
    }
    
    lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = Theme.current.slideUpContColor
        return view
    }()
    
    
    lazy var imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "")
       return img
    }()
    
    lazy var productNameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    lazy var productTypeLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "", false, Theme.current.grayLabelColor5, .left)
        return l
    }()
    
    lazy var productCostLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(18, "", false, Theme.current.grayLabelColor7, .left)
        return l
    }()
    
    lazy var previousProductCostLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "", false, Theme.current.redColor, .left, isneedStrikethrough: true)
        return l
    }()
    
    lazy var productInfoTextView: UITextView = {
        let l = UITextView()
        l.backgroundColor = .clear
        l.isEditable = false
        l.isSelectable = false
        return l
    }()
    
    private lazy var gradientView: GradiendView = {
        let headerView = GradiendView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.masksToBounds = true
        headerView.clipsToBounds = true
        return headerView
    }()
    
    lazy var customStepper: CustomStepper = {
        let v = CustomStepper(frame: CGRect(x: 0, y: 0, width: 0, height: 55.0), isInsideInfo: true)
        v.isInsideMain = true
        v.backgroundColor = Theme.current.customStapperColor
        v.layer.cornerRadius = 5
        v.layer.borderWidth = 0.0
        v.amountLabel.attributedText = NSAttributedString.getAttrTextWith(17, "\(0)", false, UIColor(hex: "#7A7A7A"))
        v.plusView.backgroundColor = UIColor(hex: "#EDEDED")
        v.minusView.backgroundColor = UIColor(hex: "#EDEDED")
        v.imagePlusView.image = UIImage.init(named: "Step_plusIcon")?.tint(with: UIColor(hex: "#000000" ,alpha: 0.5))
        v.imageMinusView.image = UIImage.init(named: "Step_minusIcon")?.tint(with: UIColor(hex: "#000000" ,alpha: 0.5))
        return v
    }()
    
    var customButton = BaseButton(title: "В корзину", size: 15)
    
    lazy var likedImgView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "likeEmpty")
        return im
    }()
    
    lazy var likedView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#000000", alpha: 0.05)
        v.layer.cornerRadius = 36 / 2
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true
        return v
    }()

    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        customStepper.plusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPlusTapCustomStepper)))
        customStepper.minusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didMiusTapCustomStepper)))
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        likedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shouldReloadCollection?()
    }
    
    // MARK: - Methods
    
    @objc func tapped() {
        liked = liked ? false : true
        CoreDataSyncManager.shared.likeItem(by: item, shouldLike: liked)
    }
    
    func likeTapped(like: Bool) {
        let color = like ? UIColor(hex: "#FF4000", alpha: 0.05) : UIColor(hex: "#000000", alpha: 0.05)
        let image = like ? UIImage.init(named: "likeFill") : UIImage.init(named: "likeEmpty")
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.likedView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        } completion: { _ in
            self.likedView.transform = .identity
            self.likedView.backgroundColor = color
            self.likedImgView.image = image
        }
    }

    
    @objc private func didPlusTapCustomStepper() {
        self.customStepper.amountOfItem += 1
//        CoreDataSyncManager.shared.saveToCoreData(model: item!)
//        reloadData()
    }
    @objc private func didMiusTapCustomStepper() {
//        if self.customStepper.amountOfItem > 0 {
//            CoreDataSyncManager.shared.updateGoodCount(by: item?.id, shouldAdd: false)
//        }
//        reloadData()
        if customStepper.amountOfItem > 0 {
            self.customStepper.amountOfItem -= 1
        }
        
    }
    
    @objc func buttonTapped() {
        CoreDataSyncManager.shared.saveToCoreDataOrUpdateCount(model: item!, count: customStepper.amountOfItem)
    }
    
    private func reloadData() {
        let reloadableItem = self.item
        self.item = reloadableItem
    }
    
    private func configure() {
        let topLine = Utils.getTopView(color: .lightGray)
        view.addSubview(containerView)
        containerView.addSubview(topLine)
        containerView.addSubview(imageView)
        view.addSubview(productNameLabel)
        view.addSubview(productTypeLabel)
        view.addSubview(productCostLabel)
        view.addSubview(productInfoTextView)
        view.addSubview(customStepper)
        view.addSubview(customButton)
        view.addSubview(likedView)
        likedView.addSubview(likedImgView)
        view.addSubview(previousProductCostLabel)
        
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: SCREEN_SIZE.width * 0.8))
        
        likedView.anchor(top: containerView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16), size: CGSize(width: 36, height: 36))
        likedImgView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 16, height: 14))
        likedImgView.centerXAnchor.constraint(equalTo: likedView.centerXAnchor).isActive = true
        likedImgView.centerYAnchor.constraint(equalTo: likedView.centerYAnchor).isActive = true
      
        topLine.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: SCREEN_SIZE.width * 0.4, height: SCREEN_SIZE.width * 0.4))
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        productNameLabel.anchor(top: containerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: likedView.leadingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        productTypeLabel.anchor(top: productNameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 16))
        productCostLabel.anchor(top: productTypeLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 0), size: CGSize(width: 100, height: 20))
        
        customStepper.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 0), size: CGSize(width: SCREEN_SIZE.width * 0.4, height: 55))
        customButton.anchor(top: nil, leading: customStepper.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 16), size: CGSize(width: 0, height: 55))
        previousProductCostLabel.anchor(top: nil, leading: productCostLabel.trailingAnchor, bottom: productCostLabel.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 16))
        
        productInfoTextView.anchor(top: productCostLabel.bottomAnchor, leading: view.leadingAnchor, bottom: customStepper.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
   
    }
}
