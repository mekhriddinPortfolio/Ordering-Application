//
//  ProfileAddressController.swift
//  Oq ot
//
//  Created by AvazbekOS on 06/07/22.
//
// mekhr

import UIKit

class ProfileAddressController: BaseViewController, UICollectionViewDelegate {

    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
    var data: [EachAddress]? {
        didSet {
            if let data = data {
                if (data.isEmpty) {
                    emptyCaseView.isHidden = false
                    collectionView.isHidden = true
                } else {
                    emptyCaseView.isHidden = true
                    collectionView.isHidden = false
                }
            }
            collectionView.reloadData()
        }
    }
    var selectedIndex: Int = 0
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()

    let viewModel = ProfileViewModel()
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Do adress stuff here
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmptyCondition()
        setupView()
        emptyCaseView.actionButton.addTarget(self, action: #selector(goForYandexTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = twoLineTitleView(text: "myLocation".translate(), color: UIColor.white)
        self.tabBarController?.tabBar.isHidden = false
        print("HELLOOO")
        self.viewModel.getAddressList()
        data = CoreDataSyncManager.shared.fetchAdresses()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = view.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(l, at: 0)
        return l
    }()
    
    let emptyCaseView = EmptyReusableView(imageName: "addressEmptyImg", text: "Список адресов пуст", desc: "Список ваших адресов пуст, пожалуйста добавьте ваш адрес", buttonTitle: "Добавить адрес", height: 165*RatioCoeff.height, leftRightPadding: 110*RatioCoeff.width)
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteColor
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ProfileAddressCell.self, forCellWithReuseIdentifier: String(describing: ProfileAddressCell.self))
        collection.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
        collection.alwaysBounceVertical = true
        return collection
    }()
 
    
    private func setupView() {
        let plusImage = UIImage.imageWithImage(image: UIImage.init(named: "plusButton")!, scaledToSize: CGSize(width: 42, height: 42))
        let plusButton = UIBarButtonItem(image: plusImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapNewAddress))
        navigationItem.rightBarButtonItem = plusButton
        
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(containerView, aboveSubview: backgroundImageView)
        
        containerView.addSubview(collectionView)
        containerView.insertSubview(emptyCaseView, aboveSubview: collectionView)
        
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: (screenSize.width - 50), height: (screenSize.width - 50) * 2 / 3))
        
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        
        collectionView.anchor(top: containerView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        self.emptyCaseView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 40 * RatioCoeff.height)
        collectionViewHeightConstraint.isActive = true
        
        emptyCaseView.buttonAction = { [weak self] in
            guard let self = self else {return}
            self.didTapNewAddress()
        }
    }
    
    @objc func goForYandexTapped() {
        self.perform(transition: YandexMapController())
    }
    
    func setEmptyCondition() {
        if data == nil || data?.isEmpty ?? true {
            emptyCaseView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyCaseView.isHidden = true
            collectionView.isHidden = false
        }
    }

}

extension ProfileAddressController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileAddressCell.self), for: indexPath) as! ProfileAddressCell
        if let text = data?[indexPath.row].address {
            cell.setItem(item: text)
            if text == UD.selectedAddress {
                cell.imageV.image = UIImage(named: "CheckmarkCircle")
                selectedIndex = indexPath.row
            } else {
                cell.imageV.image = UIImage(named: "EmptyCircle")
            }
        }
        
        cell.settingsView.addGestureRecognizer(MapGesture(target: self, action: #selector(settingsTapped(_:)), model: data!, indexPath: indexPath))
        cell.deleteView.addGestureRecognizer(MapGesture(target: self, action: #selector(deleteTapped(_:)), model: data!, indexPath: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? ProfileAddressCell {
            cell.imageV.image = UIImage(named: "EmptyCircle")
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileAddressCell {
            cell.imageV.image = UIImage(named: "CheckmarkCircle")
            UD.selectedAddress = cell.titleLabel.text!
            selectedIndex = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileAddressCell {
            cell.imageV.image = UIImage(named: "EmptyCircle")
        }
    }
    
    @objc private func didTapNewAddress() {
        self.perform(transition: YandexMapController())
    }
    
    @objc func settingsTapped(_ gest: MapGesture) {
        let vc = YandexMapController()
        vc.addressID = gest.model?[gest.indexPath?.row ?? 0].id ?? ""
        self.perform(transition: vc)
    }
    
    @objc func deleteTapped(_ gest: MapGesture) {
        UD.selectedAdressIndex = nil
        viewModel.deleteAddressById(id: gest.model?[gest.indexPath?.row ?? 0].id ?? "")
        CoreDataSyncManager.shared.deleteAddress(by: gest.model?[gest.indexPath?.row ?? 0].id ?? "")

        self.viewModel.getAddressList()
        Utils.delay(seconds: 1) {
            self.data = CoreDataSyncManager.shared.fetchAdresses()
        }

    }
}

extension ProfileAddressController {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath)
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: 30.0)
    }
    
}


