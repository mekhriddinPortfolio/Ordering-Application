//
//  PickupAddressViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 31/07/22.
//

import UIKit

protocol PickupAddressDelegate: AnyObject {
    func didChooseFromMap()
}

class PickupAddressViewController: UIViewController, UICollectionViewDelegate {
    
    var data: [EachStore]? = nil {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: PickupAddressDelegate?
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    @objc func confirmButtonTapped() {
        print("Готово Button Tapped")
        
        // down PickupAddressView and to save changes in address....
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(YandexAddressesViewCell.self, forCellWithReuseIdentifier: String(describing: YandexAddressesViewCell.self))
        collection.alwaysBounceVertical = true
        
        return collection
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorLineBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var pickupAddresslabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "selectItem".translate(), false, UIColor(hex: "#7A7A7A"), .center)
        return l
    }()
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "done".translate(), false, UIColor(hex: "#000000", alpha: 0.3)), for: .normal)
        l.contentHorizontalAlignment = .center
        l.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return l
    }()
    
    lazy var choosePickupView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.setStyleWithShadow(cornerRadius: 5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMapFormalization)))
        return view
    }()
    
    lazy var choosePickImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "")
        return img
    }()
    
    lazy var choosePickupLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(13, "addAddress".translate(), false, UIColor(hex: "#7A7A7A"), .left)
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMapFormalization)))
        return l
    }()
    
    private func setupView() {
        view.addSubview(separatorView)
        view.addSubview(pickupAddresslabel)
        view.addSubview(collectionView)
        
       
        separatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 49, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickupAddresslabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        
        collectionView.anchor(top: pickupAddresslabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 40 * RatioCoeff.height)
        collectionViewHeightConstraint.isActive = true
        
        choosePickupView.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0), size: CGSize(width: 36, height: 36))
        choosePickImage.anchor(top: choosePickupView.topAnchor, leading: choosePickupView.leadingAnchor, bottom: choosePickupView.bottomAnchor, trailing: choosePickupView.trailingAnchor, padding: UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11))
        
        choosePickupLabel.anchor(top: nil, leading: choosePickupView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        choosePickupLabel.centerYAnchor.constraint(equalTo: choosePickupView.centerYAnchor).isActive = true
    }
    
    @objc private func didTapMapFormalization() {
        self.dismiss(animated: true) {
            self.delegate?.didChooseFromMap()
        }
    }

}

extension PickupAddressViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: YandexAddressesViewCell.self), for: indexPath) as! YandexAddressesViewCell
        
        if let text = data?[indexPath.row].address {
        cell.setItem(item: text)
        }
        cell.isUserInteractionEnabled = true
        cell.imageV.image = UIImage(named: "EmptyCircle")
        cell.layer.addBorder(edge: .bottom, color: UIColor(hex: "#F2F2F2"), thickness: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - (2*16), height: 40 * RatioCoeff.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YandexAddressesViewCell {
            cell.imageV.image = UIImage(named: "CheckmarkCircle")
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YandexAddressesViewCell {
            cell.imageV.image = UIImage(named: "EmptyCircle")
        }
    }
}
