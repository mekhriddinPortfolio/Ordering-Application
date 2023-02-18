//
//  ProfileAddressController.swift
//  Oq ot
//
//  Created by AvazbekOS on 06/07/22.
//

import UIKit

class ProfileAddressController: BaseViewController, UICollectionViewDelegate {

    let cellID = "ProfileAddressCellID"
    let data: [ProfileAddressDataModel] = [
        ProfileAddressDataModel(title: "1901 Thornridge Cir. Shiloh, Hawaii 81063"),
        ProfileAddressDataModel(title: "3891 Ranchview Dr. Richardson, California 62639"),
        ProfileAddressDataModel(title: "2464 Royal Ln. Mesa, New Jersey 45463"),
    ]
//    lazy var heightOfCollectionView: CGFloat = 0.0 {
//        didSet {
//            print("heightOFVIEW")
//            Utils.delay(seconds: 0) {
//                self.collectionView.reloadData()
//            }
//        }
//    }
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ProfileAddressCell.self, forCellWithReuseIdentifier: "ProfileAddressCellID")
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    let titleBottom: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(14, "У вас больше нет добавленных адресов", false, UIColor(hex: "#000000", alpha: 0.3), .center)
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        print("SET UPView")
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 16))
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 40 * RatioCoeff.height)
        collectionViewHeightConstraint.isActive = true
        
        collectionView.register(ProfileAddressCell.self, forCellWithReuseIdentifier: "ProfileAddressCellID")
        
        
        view.addSubview(titleBottom)
        titleBottom.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 62, bottom: 0, right: 62), size: CGSize(width: 0, height: 16))
    }
    


}

extension ProfileAddressController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CELLS COLLECTION")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProfileAddressCell
        let text = data[indexPath.item]
        cell.setItem(item: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("CELLS SIZES")
        return CGSize(width: view.frame.size.width - (2*16), height: 40 * RatioCoeff.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileAddressCell {
            cell.imageV.image = UIImage(named: "checkmarkCircle")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileAddressCell {
            cell.imageV.image = UIImage(named: "emptyCircle")
        }
    }
    
}

struct ProfileAddressDataModel {
    let title: String?
}
