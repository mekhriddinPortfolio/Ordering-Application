//
//  KvOrOfficeView.swift
//  Oq ot
//
//  Created by AvazbekOS on 28/08/22.
//

import UIKit

class KvOrOfficeViewController: BaseViewController {

    var chosenDestinationType: ((_ type: Int, _ nameType: String) -> Void)?
    let data = ["Квартиры", "Дом", "Офис"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")

        view.layer.cornerRadius = 20
        view.setStyleWithShadow(cornerRadius: 20)
    }
    
    @objc func apartmentButtonTapped() {
        dismiss(animated: true) {
            self.chosenDestinationType?(0, "flat".translate())
        }
    }
    @objc func houseButtonTapped() {
        dismiss(animated: true) {
            self.chosenDestinationType?(1, "house".translate())
        }
    }
    @objc func officeButtonTapped() {
        dismiss(animated: true) {
            self.chosenDestinationType?(2, "office".translate())
        }
    }
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorLineBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    lazy var textlabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "appeal".translate(), false, UIColor(hex: "#7A7A7A"), .center)
        
        return l
    }()
    

    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(MenuSlidingVIewControllerCell.self, forCellWithReuseIdentifier: String.init(describing: MenuSlidingVIewControllerCell.self))
        return collection

    }()
    lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "techHelp".translate(), false, UIColor(hex: "#000000", alpha: 0.5), .center)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var apartmentButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "flat".translate(), false, UIColor(hex: "#FFFFFF")), for: .normal)
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(apartmentButtonTapped), for: .touchUpInside)
        return l
    }()
    
    lazy var houseButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "house".translate(), false, UIColor(hex: "#FFFFFF")), for: .normal)
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(houseButtonTapped), for: .touchUpInside)
        return l
    }()
    
    lazy var officeButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "office".translate(), false, UIColor(hex: "#FFFFFF")), for: .normal)
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(officeButtonTapped), for: .touchUpInside)
        return l

    }()

    
    private func setupView() {
        view.addSubview(separatorView)
        view.addSubview(textlabel)
        view.addSubview(itemsCollectionView)
        
        separatorView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textlabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        // 60+
    
        
        itemsCollectionView.anchor(top: textlabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: SCREEN_SIZE.width, height: (SCREEN_SIZE.height * 0.5) - 60))
    }

}

extension KvOrOfficeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MenuSlidingVIewControllerCell.self), for: indexPath) as! MenuSlidingVIewControllerCell
        cell.label.text = data[indexPath.row]
        cell.layer.addBorder(edge: .bottom, color: UIColor(hex: "#7A7A7A", alpha: 0.08), thickness: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            apartmentButtonTapped()
        case 1:
            houseButtonTapped()
        case 2:
            officeButtonTapped()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemsCollectionView.frame.size.width, height: 45)
    }

}
