//
//  BottomAddressViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 20/07/22.
//

import UIKit


protocol SlidingAddressProtocol: AnyObject {
    func addNewLocation()
    func editAddressById(id: String)
    func deleteAddressById(id: String)
}

class BottomAddressViewController: BaseViewController, UICollectionViewDelegate {

    let bottomStaticView = BottomAdressButtonView()
    var data: [Any]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var didSelectItem: ((_ data: Any) -> Void)?
    weak var delegate: SlidingAddressProtocol?
    var viewDisappeared: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.layer.cornerRadius = 20
        view.backgroundColor = Theme.current.whiteColor
        bottomStaticView.confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReady)))
        bottomStaticView.addNewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNewAddress)))
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = data as? [EachAddress] {
            self.selectDefaultAddress()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDisappeared?()
    }
    

    
    private func selectDefaultAddress() {
        collectionView.cellForItem(at: IndexPath(row: UD.selectedAdressIndex ?? 0, section: 0))?.isSelected = true
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        collection.register(BottomAddressCell.self, forCellWithReuseIdentifier: String(describing: BottomAddressCell.self))
        collection.alwaysBounceVertical = true
        
        return collection
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.searchAndIconsColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    lazy var myAddresslabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "myAddress".translate(), false, Theme.current.headlinesColor, .center)
        return l
    }()
 
    private func setupView() {
        view.addSubview(separatorView)
        view.addSubview(myAddresslabel)
        view.addSubview(collectionView)
        view.addSubview(bottomStaticView)
        separatorView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myAddresslabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        let count = data?.isEmpty == true ? 0.1 : CGFloat(data?.count ?? 1)
        collectionView.anchor(top: myAddresslabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: count * (50 * RatioCoeff.height)))
        bottomStaticView.anchor(top: collectionView.bottomAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor,size: CGSize(width: 0, height: 130))
    }
    
   
}

extension BottomAddressViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BottomAddressCell.self), for: indexPath) as! BottomAddressCell
        cell.layer.addBorder(edge: .bottom, color: Theme.current.searchAndIconsColor, thickness: 1)
            if let unwrappedData = data as? [EachAddress] {
                let data = unwrappedData[indexPath.row]
                cell.setItem(item: data.address)
                cell.settingsView.addGestureRecognizer(MapGesture(target: self, action: #selector(settingsTapped(_:)), model: unwrappedData, indexPath: indexPath))
                cell.deleteView.addGestureRecognizer(MapGesture(target: self, action: #selector(deleteTapped(_:)), model: unwrappedData, indexPath: indexPath))
            } else if let apiData = data as? [EachStore] {
                let data = apiData[indexPath.row]
                cell.setItem(item: data.address ?? "")
                cell.settingsView.isHidden = true
                cell.deleteView.isHidden = true
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50 * RatioCoeff.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach({$0.isSelected = false})
        if let cell = collectionView.cellForItem(at: indexPath) as? BottomAddressCell {
            cell.isSelected = true
            if let unwrappedData = data as? [EachAddress] {
                didSelectItem?(unwrappedData[indexPath.row])
            } else if let apiData = data as? [EachStore] {
                didSelectItem?(apiData[indexPath.row])
            }
        }
    }

    @objc private func didTapNewAddress() {
        self.dismiss(animated: true) {
            self.delegate?.addNewLocation()
        }
    }
    @objc private func didTapReady() {
        self.dismiss(animated: true) {
            self.collectionView.visibleCells.forEach { cell in
                if let cell = cell as? BottomAddressCell {
                    if cell.isSelected == true {
                        let index = self.collectionView.indexPath(for: cell)
                        UD.selectedAdressIndex = index?.row
                    }
                }
            }
            
        }
    }
    
    
    @objc func settingsTapped(_ gest: MapGesture) {
        self.dismiss(animated: true) {
            self.delegate?.editAddressById(id: gest.model?[gest.indexPath?.row ?? 0].id ?? "")
        }
    }
    
    @objc func deleteTapped(_ gest: MapGesture) {
        self.dismiss(animated: true) {
            self.delegate?.deleteAddressById(id: gest.model?[gest.indexPath?.row ?? 0].id ?? "")
        }
    }
}


